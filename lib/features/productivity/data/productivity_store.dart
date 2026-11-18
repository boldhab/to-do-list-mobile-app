import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/date_storage.dart';
import '../../../core/database/mappers/task_mapper.dart';
import '../../../core/errors/database_exception.dart';
import '../../../core/errors/planner_exception.dart';
import '../../../core/utils/date_helpers.dart';
import '../../planning/domain/planner_commands.dart';
import '../../planning/domain/validation.dart';
import '../../planning/presentation/planner_provider.dart';
import '../../recurrence/domain/recurrence_rule.dart';
import '../../reminders/domain/reminder_rule.dart';
import '../../tasks/domain/entities/task.dart';

final productivityStoreProvider = Provider<ProductivityStore>(
  (ref) => ProductivityStore(
    ref.watch(appDatabaseProvider),
    ref.watch(plannerServiceProvider),
  ),
);

typedef TaskDraft = ({
  String title,
  String description,
  DateTime date,
  TaskPriority priority,
  bool completed,
  DateTime? dueAt,
  String? goalId,
});

typedef TaskOptions = ({
  RecurrenceRule? repeat,
  ReminderDraft? reminder,
  SeriesScope scope,
});

class ProductivityStore {
  ProductivityStore(this.db, this.commands);

  final AppDatabase db;
  final PlannerCommands commands;

  SimpleSelectStatement<$RecurrenceRulesTable, RecurrenceRow> _rule(
    String id,
  ) => db.select(db.recurrenceRules)..where((row) => row.taskId.equals(id));
  SimpleSelectStatement<$OccurrenceStatesTable, OccurrenceRow> _occurrence(
    OccurrenceId id,
  ) => db.select(db.occurrenceStates)
    ..where(
      (row) => row.taskId.equals(id.series) & row.occurrenceDay.equals(id.day),
    );
  SimpleSelectStatement<$ReminderRulesTable, ReminderRow> _reminder(
    String id,
  ) => db.select(db.reminderRules)..where((row) => row.id.equals(id));

  RecurrenceRule decodeRule(RecurrenceRow row) => RecurrenceRule(
    frequency: RecurrenceFrequency.values.byName(row.frequency),
    start: decodeDay(row.startDay),
    interval: row.interval,
    weekdays: row.weekdays,
    monthDay: row.monthDay,
    end: row.endDay == null ? null : decodeDay(row.endDay!),
    count: row.occurrenceCount,
  );

  ReminderDraft? decodeReminder(ReminderRow? row) => row == null || !row.enabled
      ? null
      : ReminderDraft(
          minutesBefore: row.minutesBefore,
          customAt: row.absoluteTime?.toLocal(),
        );

  Future<ReminderDraft?> _effectiveReminder(
    String id,
    OccurrenceId? occurrence,
    PlannerTask? projected,
  ) async {
    final own = await _reminder(id).getSingleOrNull();
    if (own != null || occurrence == null) return decodeReminder(own);
    final inherited = decodeReminder(
      await _reminder(occurrence.series).getSingleOrNull(),
    );
    if (inherited?.customAt == null || projected == null) return inherited;
    final master = await db.taskDao.byId(occurrence.series);
    if (master == null) return inherited;
    return ReminderDraft(
      customAt: shiftTimestamp(
        inherited!.customAt,
        decodeDay(master.scheduledDate),
        projected.scheduledDate,
      ),
    );
  }

  Stream<TaskOptions> watchOptions(String id) => watchChanges(
    {...taskTables, db.reminderRules},
    () async {
      final occurrence = parseOccurrence(id);
      final row = await _rule(occurrence?.series ?? id).getSingleOrNull();
      return (
        repeat: row == null ? null : decodeRule(row),
        reminder: await _effectiveReminder(
          id,
          occurrence,
          occurrence == null ? null : await getTask(id),
        ),
        scope: occurrence == null ? SeriesScope.series : SeriesScope.occurrence,
      );
    },
  );

  Stream<T> watchChanges<T>(
    Set<ResultSetImplementation> tables,
    Future<T> Function() read,
  ) async* {
    await db.customSelect('SELECT 1').getSingle();
    // Drift caches watches by SQL and parameters. Key this invalidation query
    // by its table set so it cannot reuse an unrelated subscription.
    final names = tables.map((table) => table.entityName).toList()..sort();
    yield* db
        .customSelect(
          'SELECT 1 /* watched: ${names.join(',')} */',
          readsFrom: tables,
        )
        .watch()
        .asyncMap((_) => db.transaction(read));
  }

  Set<ResultSetImplementation> get taskTables => {
    db.tasks,
    db.recurrenceRules,
    db.occurrenceStates,
  };

  Stream<List<PlannerTask>> watchRange(DateTime from, DateTime through) =>
      watchChanges(
        taskTables,
        () => forRange(from, through),
      ).distinct(listEquals);

  Stream<List<PlannerTask>> watchUpcoming(DateTime from) => watchChanges(
    taskTables,
    () => forRange(from, null, pendingOnly: true),
  ).distinct(listEquals);

  Stream<PlannerTask?> watchTask(String id) =>
      watchChanges(taskTables, () => getTask(id)).distinct();

  Future<PlannerTask?> getTask(String id) async {
    final occurrence = parseOccurrence(id);
    if (occurrence == null) {
      final task = await db.taskDao.byId(id);
      return task == null ? null : taskFromRow(task);
    }
    final series = await _rule(occurrence.series).getSingleOrNull();
    final template = await db.taskDao.byId(occurrence.series);
    if (series == null || template == null) return null;
    final state = await _occurrence(occurrence).getSingleOrNull();
    if (state?.skipped ?? false) return null;
    final date = decodeDay(occurrence.day);
    if (state == null && decodeRule(series).between(date, date).isEmpty) {
      return null;
    }
    return _project(template, occurrence.day, state);
  }

  /// Null upper bound includes every standalone match and projects only the
  /// next 30 days of open-ended series.
  Future<List<PlannerTask>> forRange(
    DateTime from,
    DateTime? through, {
    bool pendingOnly = false,
    DateTime? seriesFrom,
    DateTime? seriesThrough,
  }) async {
    final low = encodeDay(from);
    final high = through == null ? null : encodeDay(through);
    final seriesLow = seriesFrom == null ? low : encodeDay(seriesFrom);
    final seriesHigh = seriesThrough == null
        ? high ?? encodeDay(shiftDay(from, 29))
        : encodeDay(seriesThrough);
    final tasks = db.tasks;
    final rules = db.recurrenceRules;
    final states = db.occurrenceStates;
    final ordinary =
        db.select(tasks).join([
          leftOuterJoin(
            rules,
            rules.taskId.equalsExp(tasks.id),
            useColumns: false,
          ),
        ])..where(
          rules.taskId.isNull() &
              tasks.scheduledDate.isBiggerOrEqualValue(low) &
              (high == null
                  ? const Constant(true)
                  : tasks.scheduledDate.isSmallerOrEqualValue(high)) &
              (pendingOnly
                  ? tasks.isCompleted.equals(false)
                  : const Constant(true)),
        );
    final result = (await ordinary.get())
        .map((row) => taskFromRow(row.readTable(tasks)))
        .toList();
    final changed =
        await (db.select(states)..where(
              (row) =>
                  row.occurrenceDay.isBetweenValues(seriesLow, seriesHigh) |
                  row.scheduledDay.isBetweenValues(seriesLow, seriesHigh),
            ))
            .get();
    final grouped = <String, Map<int, OccurrenceRow>>{};
    for (final row in changed) {
      (grouped[row.taskId] ??= {})[row.occurrenceDay] = row;
    }
    final templates =
        db.select(rules).join([
          innerJoin(tasks, tasks.id.equalsExp(rules.taskId)),
        ])..where(
          (rules.startDay.isSmallerOrEqualValue(seriesHigh) &
                  (rules.endDay.isNull() |
                      rules.endDay.isBiggerOrEqualValue(seriesLow))) |
              rules.taskId.isIn(grouped.keys),
        );
    for (final record in await templates.get()) {
      final rule = record.readTable(rules);
      final template = record.readTable(tasks);
      final overrides = grouped[rule.taskId] ?? const <int, OccurrenceRow>{};
      final dates = {
        ...decodeRule(rule)
            .between(decodeDay(seriesLow), decodeDay(seriesHigh))
            .map(encodeDay),
        ...overrides.keys,
      };
      for (final day in dates) {
        final state = overrides[day];
        if (state?.skipped ?? false) continue;
        final effective = state?.scheduledDay ?? day;
        if (effective < seriesLow || effective > seriesHigh) continue;
        if (pendingOnly && state?.completedAt != null) continue;
        result.add(_project(template, day, state));
      }
    }
    result.sort((a, b) {
      final order = a.scheduledDate.compareTo(b.scheduledDate);
      return order == 0 ? a.id.compareTo(b.id) : order;
    });
    return result;
  }

  DateTime? shiftTimestamp(
    DateTime? timestamp,
    DateTime oldDate,
    DateTime newDate,
  ) {
    if (timestamp == null) return null;
    final local = timestamp.toLocal();
    final target = shiftDay(newDate, encodeDay(local) - encodeDay(oldDate));
    return DateTime(
      target.year,
      target.month,
      target.day,
      local.hour,
      local.minute,
      local.second,
      local.millisecond,
      local.microsecond,
    );
  }

  PlannerTask _project(TaskRow source, int day, OccurrenceRow? state) {
    final task = taskFromRow(source);
    final override = state?.overrideData == null
        ? null
        : jsonDecode(state!.overrideData!) as Map<String, dynamic>;
    final scheduled = decodeDay(state?.scheduledDay ?? day);
    return PlannerTask(
      id: occurrenceKey(task.id, day),
      title: override?['title'] as String? ?? task.title,
      description: override == null
          ? task.description
          : override['description'] as String?,
      priority: override == null
          ? task.priority
          : TaskPriority.values.byName(override['priority'] as String),
      scheduledDate: scheduled,
      dueAt: override == null
          ? shiftTimestamp(task.dueAt, task.scheduledDate, scheduled)
          : DateTime.tryParse(override['dueAt'] as String? ?? '')?.toLocal(),
      isCompleted: state?.completedAt != null,
      completedAt: state?.completedAt?.toLocal(),
      createdAt: task.createdAt,
      updatedAt: state?.updatedAt.toLocal() ?? task.updatedAt,
    );
  }

  Future<void> save(String? id, TaskDraft draft, TaskOptions options) =>
      databaseOperation(
        'save task and options',
        () => db.transaction(() async {
          validateYear(draft.date.year);
          if (draft.dueAt case final deadline?) validateYear(deadline.year);
          final occurrence = id == null ? null : parseOccurrence(id);
          final repeat = options.repeat;
          if (repeat != null) repeat.validate();
          if ((repeat != null || occurrence != null) && draft.goalId != null) {
            throw PlannerException(
              'Keep repeating tasks independent of weekly goals.',
            );
          }
          final reminderAt = options.reminder?.fireAt(draft.dueAt);
          final previous = id == null ? null : await getTask(id);
          final savedReminder = id == null
              ? null
              : await _effectiveReminder(id, occurrence, previous);
          final sameRule =
              savedReminder?.minutesBefore == options.reminder?.minutesBefore &&
              savedReminder?.customAt?.toUtc() ==
                  options.reminder?.customAt?.toUtc() &&
              (savedReminder == null) == (options.reminder == null);
          final unchangedReminder =
              sameRule &&
              (savedReminder?.customAt != null ||
                  previous?.dueAt?.toUtc() == draft.dueAt?.toUtc());
          if (options.reminder != null &&
              (reminderAt == null ||
                  (!reminderAt.isAfter(DateTime.now()) &&
                      !unchangedReminder))) {
            throw PlannerException(
              'Choose a future reminder time and add a deadline for relative reminders.',
            );
          }
          if (occurrence != null && options.scope == SeriesScope.occurrence) {
            if (previous == null) {
              throw PlannerException('This occurrence no longer exists.');
            }
            await _writeState(occurrence, draft, previous);
            if (!sameRule) {
              await _writeReminder(
                id!,
                occurrence.series,
                occurrence.day,
                options.reminder,
              );
            }
            return;
          }

          if (occurrence != null && repeat == null) {
            throw PlannerException(
              'Use Delete this and future to end a repeating series.',
            );
          }
          final all = occurrence != null && options.scope == SeriesScope.series;
          final seriesId = all
              ? occurrence.series
              : occurrence == null
              ? id
              : null;
          final oldRule = occurrence == null
              ? null
              : await _rule(occurrence.series).getSingleOrNull();
          if (occurrence != null && oldRule == null) {
            throw PlannerException('This series no longer exists.');
          }
          if (occurrence != null && !all) {
            if (encodeDay(draft.date) < occurrence.day) {
              throw PlannerException(
                'This and future occurrences cannot start before the selected occurrence.',
              );
            }
            await _endSeries(occurrence);
          }
          final templateDate = all ? repeat!.start : draft.date;
          final templateDeadline = all
              ? shiftTimestamp(draft.dueAt, draft.date, templateDate)
              : draft.dueAt;
          final task = await commands.saveTask(
            id: seriesId,
            title: draft.title,
            description: draft.description,
            date: templateDate,
            priority: draft.priority,
            completed: repeat == null && draft.completed,
            dueAt: templateDeadline,
            weeklyGoalId: draft.goalId,
          );
          if (repeat != null) {
            final next = occurrence != null && !all
                ? repeat.starting(draft.date)
                : repeat;
            await _writeRecurrence(task.id, next);
            if (draft.completed && !all) {
              final first = next
                  .between(next.start, shiftDay(next.start, 370))
                  .firstOrNull;
              if (first != null) {
                final key = (series: task.id, day: encodeDay(first));
                await _writeState(key, null, task, completing: true);
              }
            }
          }
          final reminder = options.reminder;
          await _writeReminder(
            task.id,
            task.id,
            null,
            all && reminder?.customAt != null
                ? ReminderDraft(
                    customAt: shiftTimestamp(
                      reminder!.customAt,
                      draft.date,
                      templateDate,
                    ),
                  )
                : reminder,
          );
        }),
      );

  Future<void> _writeRecurrence(String id, RecurrenceRule rule) async {
    rule.validate();
    validateYear(rule.start.year);
    if (rule.end case final end?) validateYear(end.year);
    final now = DateTime.now().toUtc();
    final previous = await _rule(id).getSingleOrNull();
    await db
        .into(db.recurrenceRules)
        .insertOnConflictUpdate(
          RecurrenceRow(
            taskId: id,
            frequency: rule.frequency.name,
            interval: rule.interval,
            weekdays: rule.weekdays,
            monthDay: rule.monthDay,
            startDay: encodeDay(rule.start),
            endDay: rule.end == null ? null : encodeDay(rule.end!),
            occurrenceCount: rule.count,
            createdAt: previous?.createdAt ?? now,
            updatedAt: now,
          ),
        );
  }

  Future<void> _writeReminder(
    String id,
    String series,
    int? day,
    ReminderDraft? reminder,
  ) async {
    final now = DateTime.now().toUtc();
    final previous = await _reminder(id).getSingleOrNull();
    if (reminder == null && day == null) {
      if (previous != null) {
        await (db.delete(
          db.reminderRules,
        )..where((row) => row.id.equals(id))).go();
      }
      return;
    }
    await db
        .into(db.reminderRules)
        .insertOnConflictUpdate(
          ReminderRow(
            id: id,
            taskId: series,
            occurrenceDay: day,
            minutesBefore: reminder?.minutesBefore,
            absoluteTime: reminder?.customAt?.toUtc(),
            enabled: reminder != null,
            createdAt: previous?.createdAt ?? now,
            updatedAt: now,
          ),
        );
  }

  Future<void> _writeState(
    OccurrenceId id,
    TaskDraft? draft,
    PlannerTask previous, {
    bool? completing,
    bool skipped = false,
  }) async {
    final state = await _occurrence(id).getSingleOrNull();
    final now = DateTime.now().toUtc();
    final completed = completing ?? draft?.completed ?? previous.isCompleted;
    await db
        .into(db.occurrenceStates)
        .insertOnConflictUpdate(
          OccurrenceRow(
            taskId: id.series,
            occurrenceDay: id.day,
            scheduledDay: draft == null
                ? state?.scheduledDay ?? id.day
                : encodeDay(draft.date),
            overrideData: draft == null
                ? state?.overrideData
                : jsonEncode({
                    'title': validatedTitle(draft.title),
                    'description': cleanDescription(draft.description),
                    'dueAt': draft.dueAt?.toUtc().toIso8601String(),
                    'priority': draft.priority.name,
                  }),
            skipped: skipped,
            completedAt: completed
                ? previous.completedAt?.toUtc() ?? now
                : null,
            updatedAt: now,
          ),
        );
  }

  Future<void> toggle(String id) async {
    final occurrence = parseOccurrence(id);
    if (occurrence == null) {
      await commands.toggleTask(id);
      return;
    }
    await databaseOperation(
      'update occurrence completion',
      () => db.transaction(() async {
        final previous = await getTask(id);
        if (previous == null) {
          throw PlannerException('This occurrence no longer exists.');
        }
        await _writeState(
          occurrence,
          null,
          previous,
          completing: !previous.isCompleted,
        );
      }),
    );
  }

  Future<void> delete(String id, SeriesScope scope) async {
    final occurrence = parseOccurrence(id);
    if (occurrence == null || scope == SeriesScope.series) {
      await commands.deleteTask(occurrence?.series ?? id);
      return;
    }
    await databaseOperation(
      'delete occurrence',
      () => db.transaction(() async {
        final previous = await getTask(id);
        if (previous == null) {
          throw PlannerException('This occurrence no longer exists.');
        }
        if (scope == SeriesScope.future) {
          await _endSeries(occurrence);
        } else {
          await _writeState(
            occurrence,
            null,
            previous,
            completing: false,
            skipped: true,
          );
        }
      }),
    );
  }

  Future<void> _endSeries(OccurrenceId id) async {
    final end = id.day - 1;
    final now = DateTime.now().toUtc();
    await (db.update(
      db.recurrenceRules,
    )..where((row) => row.taskId.equals(id.series))).write(
      RecurrenceRulesCompanion(endDay: Value(end), updatedAt: Value(now)),
    );
    await (db.delete(db.occurrenceStates)..where(
          (row) =>
              row.taskId.equals(id.series) &
              row.occurrenceDay.isBiggerOrEqualValue(id.day),
        ))
        .go();
    await (db.delete(db.reminderRules)..where(
          (row) =>
              row.taskId.equals(id.series) &
              row.occurrenceDay.isBiggerOrEqualValue(id.day),
        ))
        .go();
  }
}
