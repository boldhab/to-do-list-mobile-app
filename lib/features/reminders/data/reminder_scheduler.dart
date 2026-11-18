import '../../../core/database/app_database.dart';
import '../../../core/database/date_storage.dart';
import '../../../core/utils/date_helpers.dart';
import '../../productivity/data/preferences.dart';
import '../../productivity/data/productivity_store.dart';
import '../../recurrence/domain/recurrence_rule.dart';
import '../../tasks/domain/entities/task.dart';
import 'notification_gateway.dart';

typedef PlannedReminder = ({PlannerTask task, DateTime at});

class ReminderScheduler {
  ReminderScheduler(this.store, this.gateway, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;

  final ProductivityStore store;
  final NotificationGateway gateway;
  final DateTime Function() clock;
  AppDatabase get db => store.db;

  Future<bool> reconcile() async {
    final zone = await gateway.refreshTimezone();
    final permission = await gateway.allowed();
    final pending = await gateway.pending();
    final desired = await db.transaction<List<PlannedReminder>>(() async {
      final settings = await PreferencesRepository(db).get();
      return settings.remindersEnabled ? await _plan(clock()) : [];
    });
    final previous = {
      for (final row in await db.select(db.reminderDeliveries).get())
        row.occurrenceKey: row,
    };
    final desiredKeys = desired.map((reminder) => reminder.task.id).toSet();
    final retainedIds = {
      if (permission)
        for (final entry in previous.entries)
          if (desiredKeys.contains(entry.key) &&
              pending[entry.value.id] == '$reminderPayloadPrefix${entry.key}')
            entry.value.id,
    };
    // Clear obsolete alarms before scheduling replacements so reconciliation
    // stays below platform limits even when the whole window changes.
    for (final id in pending.keys.where((id) => !retainedIds.contains(id))) {
      await gateway.cancel(id);
    }
    for (final reminder in desired) {
      final task = reminder.task;
      final fingerprint = '${reminder.at.toIso8601String()}|$zone';
      final row =
          previous.remove(task.id) ??
          await db
              .into(db.reminderDeliveries)
              .insertReturning(
                ReminderDeliveriesCompanion.insert(
                  occurrenceKey: task.id,
                  fingerprint: fingerprint,
                  state: 'pending',
                  fireAt: reminder.at,
                  taskId: task.id,
                ),
              );
      final id = row.id;
      var state = permission ? 'scheduled' : 'permission';
      if (permission) {
        try {
          if (!retainedIds.contains(id) ||
              row.fingerprint != fingerprint ||
              row.state != 'scheduled') {
            // Cancel first so an OS error cannot leave an obsolete alarm active.
            if (retainedIds.contains(id)) await gateway.cancel(id);
            await gateway.schedule(id, reminder.at, task.id);
          }
        } catch (_) {
          state = 'failed';
        }
      }
      await db
          .into(db.reminderDeliveries)
          .insertOnConflictUpdate(
            row.copyWith(
              fingerprint: fingerprint,
              fireAt: reminder.at,
              state: state,
            ),
          );
    }
    if (previous.isNotEmpty) {
      await (db.delete(db.reminderDeliveries)
            ..where((row) => row.id.isIn(previous.values.map((row) => row.id))))
          .go();
    }
    return permission;
  }

  Future<List<PlannedReminder>> _plan(DateTime now) async {
    final horizon = now.add(const Duration(days: 30));
    final rules = {
      for (final row in await db.select(db.reminderRules).get()) row.id: row,
    };
    if (rules.isEmpty) return [];
    final templates = {
      for (final row in await db.select(db.recurrenceRules).get())
        row.taskId: row,
    };
    final candidates = <String, PlannerTask>{};
    if (templates.isNotEmpty) {
      for (final task in await store.forRange(
        shiftDay(now, -2),
        shiftDay(now, 31),
        pendingOnly: true,
      )) {
        if (parseOccurrence(task.id) != null) candidates[task.id] = task;
      }
    }
    for (final rule in rules.values.where(
      (rule) =>
          rule.enabled &&
          (rule.occurrenceDay != null || !templates.containsKey(rule.taskId)),
    )) {
      final task = await store.getTask(rule.id);
      if (task != null && !task.isCompleted) candidates[task.id] = task;
    }
    final planned = <PlannedReminder>[];
    for (final task in candidates.values) {
      final occurrence = parseOccurrence(task.id);
      final row =
          rules[task.id] ??
          (occurrence == null ? null : rules[occurrence.series]);
      final rule = store.decodeReminder(row);
      if (rule == null) continue;
      var at = rule.fireAt(task.dueAt);
      if (row!.absoluteTime != null &&
          row.occurrenceDay == null &&
          occurrence != null) {
        final series = templates[occurrence.series]!;
        final master = await db.taskDao.byId(series.taskId);
        if (master == null) continue;
        at = store
            .shiftTimestamp(
              row.absoluteTime,
              decodeDay(master.scheduledDate),
              task.scheduledDate,
            )
            ?.toUtc();
      }
      if (at != null &&
          at.isAfter(now) &&
          (occurrence == null || !at.isAfter(horizon))) {
        planned.add((task: task, at: at));
      }
    }
    planned.sort((a, b) {
      final order = a.at.compareTo(b.at);
      return order == 0 ? a.task.id.compareTo(b.task.id) : order;
    });
    return planned.take(64).toList();
  }
}
