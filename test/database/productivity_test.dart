import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_planner/core/database/app_database.dart';
import 'package:task_planner/core/database/database_provider.dart';
import 'package:task_planner/core/database/date_storage.dart';
import 'package:task_planner/core/errors/planner_exception.dart';
import 'package:task_planner/core/utils/date_helpers.dart';
import 'package:task_planner/features/analytics/domain/productivity_metrics.dart';
import 'package:task_planner/features/productivity/data/preferences.dart';
import 'package:task_planner/features/productivity/data/productivity_store.dart';
import 'package:task_planner/features/recurrence/domain/recurrence_rule.dart';
import 'package:task_planner/features/reminders/data/notification_gateway.dart';
import 'package:task_planner/features/reminders/data/reminder_scheduler.dart';
import 'package:task_planner/features/reminders/domain/reminder_rule.dart';
import 'package:task_planner/features/search/domain/task_search.dart';
import 'package:task_planner/features/tasks/domain/entities/task.dart';

TaskDraft draft(
  DateTime date, {
  String title = 'Review goals',
  DateTime? dueAt,
  String? goalId,
}) => (
  title: title,
  description: 'Write a summary',
  date: date,
  priority: TaskPriority.high,
  completed: false,
  dueAt: dueAt,
  goalId: goalId,
);

TaskOptions options({
  RecurrenceRule? repeat,
  ReminderDraft? reminder,
  SeriesScope scope = SeriesScope.series,
}) => (repeat: repeat, reminder: reminder, scope: scope);

void main() {
  test('notification navigation only accepts planner task payloads', () {
    expect(decodeReminderPayload('task-planner:task-abc'), 'task-abc');
    expect(decodeReminderPayload('task-planner:task-abc~-20'), 'task-abc~-20');
    expect(decodeReminderPayload('task-planner:../../settings'), isNull);
    expect(decodeReminderPayload('task-planner:task-a~--20'), isNull);
    expect(decodeReminderPayload(null), isNull);
  });

  test('recurrence handles bounded daily and weekly ranges and skips missing monthly dates', () {
    final daily = RecurrenceRule(
      frequency: RecurrenceFrequency.daily,
      start: DateTime(2024, 2, 27),
      interval: 2,
      count: 3,
    );
    expect(daily.between(DateTime(2024, 2, 28), DateTime(2024, 3, 31)), [
      DateTime(2024, 2, 29),
      DateTime(2024, 3, 2),
    ]);
    final weekly = RecurrenceRule(
      frequency: RecurrenceFrequency.weekly,
      start: DateTime(2024, 2, 28),
      interval: 2,
      weekdays: 21,
      count: 4,
    );
    expect(weekly.between(DateTime(2024, 2, 1), DateTime(2024, 4, 1)), [
      DateTime(2024, 2, 28),
      DateTime(2024, 3, 1),
      DateTime(2024, 3, 11),
      DateTime(2024, 3, 13),
    ]);
    final monthly = RecurrenceRule(
      frequency: RecurrenceFrequency.monthly,
      start: DateTime(2024, 1, 1),
      monthDay: 31,
      count: 3,
    );
    expect(monthly.between(DateTime(2024, 1), DateTime(2024, 6)), [
      DateTime(2024, 1, 31),
      DateTime(2024, 3, 31),
      DateTime(2024, 5, 31),
    ]);
    expect(
      RecurrenceRule(
        frequency: RecurrenceFrequency.monthly,
        start: DateTime(2024, 2),
        monthDay: 29,
        end: DateTime(2024, 2, 29),
      ).between(DateTime(2024, 2), DateTime(2025, 1)),
      [DateTime(2024, 2, 29)],
    );
  });

  test(
    'v1 migration preserves the real schema, links, date and deadline',
    () async {
      final snapshot = jsonDecode(
        File('drift_schemas/drift_schema_v1.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      final now = DateTime.utc(2026, 11, 19, 13).toIso8601String();
      final db = AppDatabase(
        NativeDatabase.memory(
          setup: (raw) {
            for (final entry in snapshot['fixed_sql'] as List<dynamic>) {
              final statement =
                  (entry['sql'] as List<dynamic>).first['sql'] as String;
              raw.execute(statement);
            }
            raw.execute('PRAGMA user_version = 1');
            raw.execute(
              'INSERT INTO monthly_goals (id,title,year,month,created_at,updated_at) VALUES (?,?,?,?,?,?)',
              ['m', 'Month', 2026, 11, now, now],
            );
            raw.execute(
              'INSERT INTO weekly_goals (id,monthly_goal_id,title,week_start,week_end,created_at,updated_at) VALUES (?,?,?,?,?,?,?)',
              [
                'w',
                'm',
                'Week',
                encodeDay(DateTime(2026, 11, 16)),
                encodeDay(DateTime(2026, 11, 22)),
                now,
                now,
              ],
            );
            raw.execute(
              'INSERT INTO tasks (id,weekly_goal_id,title,scheduled_date,due_at,priority,created_at,updated_at) VALUES (?,?,?,?,?,?,?,?)',
              [
                't',
                'w',
                'Task',
                encodeDay(DateTime(2026, 11, 19)),
                now,
                'high',
                now,
                now,
              ],
            );
          },
        ),
      );
      addTearDown(db.close);
      final saved = await db.taskDao.byId('t');
      expect(saved?.weeklyGoalId, 'w');
      expect(saved?.scheduledDate, encodeDay(DateTime(2026, 11, 19)));
      expect(saved?.dueAt?.toUtc().toIso8601String(), now);
      expect((await db.weeklyGoalDao.byId('w'))?.monthlyGoalId, 'm');
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
      expect(
        (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
          'user_version',
        ),
        2,
      );
      expect(await db.select(db.recurrenceRules).get(), isEmpty);
      expect(await db.select(db.reminderRules).get(), isEmpty);
      expect(await PreferencesRepository(db).get(), defaultPreferences);
    },
  );

  test('preferences survive closing and reopening the file', () async {
    final directory = await Directory.systemTemp.createTemp('planner-phase4-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/planner.sqlite');
    final db = AppDatabase(NativeDatabase(file));
    await PreferencesRepository(db).update(
      (row) => row.copyWith(
        theme: 'dark',
        remindersEnabled: false,
        reminderOffset: 30,
        calendarWeek: true,
        sundayFirst: true,
        dateFormat: 'iso',
      ),
    );
    await db.close();
    final reopened = AppDatabase(NativeDatabase(file));
    addTearDown(reopened.close);
    final settings = await PreferencesRepository(reopened).watch().first;
    expect(settings.theme, 'dark');
    expect(settings.remindersEnabled, isFalse);
    expect(settings.reminderOffset, 30);
    expect(settings.calendarWeek && settings.sundayFirst, isTrue);
    expect(plannerDate(DateTime(2042, 1, 3), settings), '2042-01-03');
  });

  group('persistent recurrence and reminders', () {
    late AppDatabase db;
    late ProviderContainer container;
    late ProductivityStore store;
    final first = DateTime(2045, 3, 1);

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      store = container.read(productivityStoreProvider);
    });
    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test(
      'projections are unique and changes apply to the selected scope',
      () async {
        final rule = RecurrenceRule(
          frequency: RecurrenceFrequency.daily,
          start: first,
          count: 6,
        );
        await store.save(null, draft(first), options(repeat: rule));
        final tasks = await store.forRange(first, shiftDay(first, 8));
        expect(tasks, hasLength(6));
        expect(tasks.map((task) => task.id).toSet(), hasLength(6));
        expect(await db.taskDao.all(), hasLength(1));
        await store.toggle(tasks.first.id);
        expect((await store.getTask(tasks[0].id))?.isCompleted, isTrue);
        expect((await store.getTask(tasks[1].id))?.isCompleted, isFalse);
        final moved = shiftDay(first, 8);
        await store.save(
          tasks[1].id,
          draft(moved, title: 'One-off move'),
          options(repeat: rule, scope: SeriesScope.occurrence),
        );
        expect(
          (await store.forRange(moved, moved)).single.title,
          'One-off move',
        );
        expect(
          await store.forRange(shiftDay(first, 1), shiftDay(first, 1)),
          isEmpty,
        );

        await store.save(
          tasks[2].id,
          draft(shiftDay(first, 2), title: 'Future title'),
          options(
            repeat: RecurrenceRule(
              frequency: RecurrenceFrequency.daily,
              start: shiftDay(first, 2),
              count: 2,
            ),
            scope: SeriesScope.future,
          ),
        );
        final split = await store.forRange(first, moved);
        expect(split.map((task) => task.title), [
          'Review goals',
          'Future title',
          'Future title',
          'One-off move',
        ]);
        expect(split.first.completedAt, isNotNull);
        expect(await store.getTask(tasks[2].id), isNull);
        final next = split[1];
        await store.save(
          next.id,
          draft(next.scheduledDate, title: 'Series title'),
          options(
            repeat: RecurrenceRule(
              frequency: RecurrenceFrequency.daily,
              start: next.scheduledDate,
              count: 2,
            ),
          ),
        );
        expect((await store.getTask(next.id))?.title, 'Series title');
        await store.delete(next.id, SeriesScope.occurrence);
        expect(await store.getTask(next.id), isNull);
        await store.delete(split[2].id, SeriesScope.future);
        expect((await store.forRange(first, moved)).map((task) => task.title), [
          'Review goals',
          'One-off move',
        ]);
        await store.delete(tasks.first.id, SeriesScope.series);
        expect(await store.forRange(first, moved), isEmpty);
      },
    );

    test('invalid reminder and incompatible recurring association roll back the task', () async {
      await expectLater(
        store.save(
          null,
          draft(first),
          options(reminder: const ReminderDraft(minutesBefore: 15)),
        ),
        throwsA(isA<PlannerException>()),
      );
      await expectLater(
        store.save(
          null,
          draft(first, goalId: 'weekly'),
          options(
            repeat: RecurrenceRule(
              frequency: RecurrenceFrequency.daily,
              start: first,
            ),
          ),
        ),
        throwsA(isA<PlannerException>()),
      );
      expect(await db.taskDao.all(), isEmpty);
    });

    test('notification reconciliation honors updates, permission, and global enablement', () async {
      final gateway = FakeGateway();
      final scheduler = ReminderScheduler(store, gateway, clock: () => first);
      final due = first.add(const Duration(hours: 10));
      await store.save(
        null,
        draft(first, dueAt: due),
        options(reminder: const ReminderDraft(minutesBefore: 30)),
      );
      final task = (await store.forRange(first, first)).single;
      await scheduler.reconcile();
      expect(
        gateway.scheduled.values.single.at,
        due.toUtc().subtract(const Duration(minutes: 30)),
      );
      final originalId = gateway.scheduled.keys.single;
      final changed = due.add(const Duration(hours: 1));
      await store.save(
        task.id,
        draft(first, dueAt: changed),
        options(reminder: const ReminderDraft(minutesBefore: 5)),
      );
      await scheduler.reconcile();
      expect(gateway.scheduled.keys.single, originalId);
      expect(
        gateway.scheduled.values.single.at,
        changed.toUtc().subtract(const Duration(minutes: 5)),
      );
      gateway.permission = false;
      await scheduler.reconcile();
      expect(gateway.scheduled, isEmpty);
      expect(
        (await db.select(db.reminderDeliveries).get()).single.state,
        'permission',
      );
      gateway.permission = true;
      gateway.failScheduling = true;
      await scheduler.reconcile();
      expect(
        (await db.select(db.reminderDeliveries).get()).single.state,
        'failed',
      );
      gateway.failScheduling = false;
      await scheduler.reconcile();
      expect(gateway.scheduled, hasLength(1));
      await store.toggle(task.id);
      await scheduler.reconcile();
      expect(gateway.scheduled, isEmpty);
      await store.toggle(task.id);
      await scheduler.reconcile();
      expect(gateway.scheduled, hasLength(1));
      await PreferencesRepository(db)
          .update((row) => row.copyWith(remindersEnabled: false));
      await scheduler.reconcile();
      expect(gateway.scheduled, isEmpty);
      expect(await db.select(db.reminderRules).get(), hasLength(1));
      await PreferencesRepository(db)
          .update((row) => row.copyWith(remindersEnabled: true));
      await scheduler.reconcile();
      expect(gateway.scheduled, hasLength(1));
      await store.delete(task.id, SeriesScope.series);
      await scheduler.reconcile();
      expect(gateway.scheduled, isEmpty);
      expect(await db.select(db.reminderRules).get(), isEmpty);
    });

    test('reconciliation clears stale alarms before scheduling and reuses IDs across timezone shifts', () async {
      final gateway = FakeGateway()..maxPending = 64;
      for (var id = 100; id < 164; id++) {
        gateway.scheduled[id] = (at: first.toUtc(), taskId: 'old-$id');
      }
      final due = first.add(const Duration(hours: 2));
      await store.save(
        null,
        draft(first, dueAt: due),
        options(reminder: const ReminderDraft(minutesBefore: 15)),
      );
      final scheduler = ReminderScheduler(store, gateway, clock: () => first);
      await scheduler.reconcile();
      expect(gateway.scheduled, hasLength(1));
      final id = gateway.scheduled.keys.single;
      final ledger = (await db.select(db.reminderDeliveries).get()).single;
      expect(ledger.state, 'scheduled');
      expect(ledger.fingerprint, isNot(contains('Review goals')));
      await scheduler.reconcile();
      expect(gateway.scheduleCalls, 1);
      gateway.timezone = 'America/New_York';
      await scheduler.reconcile();
      expect(gateway.scheduled.keys.single, id);
      expect(gateway.scheduleCalls, 2);
      gateway.scheduled.clear();
      await ReminderScheduler(store, gateway, clock: () => first).reconcile();
      expect(gateway.scheduled.keys.single, id);
    });

    test(
      'a failed future split rolls back the original recurrence and completion',
      () async {
        final rule = RecurrenceRule(
          frequency: RecurrenceFrequency.daily,
          start: first,
          count: 4,
        );
        await store.save(null, draft(first), options(repeat: rule));
        final last = shiftDay(first, 3);
        final before = await store.forRange(first, last);
        await store.toggle(before.first.id);
        await db.customStatement("""
        CREATE TRIGGER reject_test_split BEFORE INSERT ON tasks
        WHEN NEW.title = 'Fail split'
        BEGIN SELECT RAISE(ABORT, 'test rollback'); END
      """);
        final boundary = before[1];
        await expectLater(
          store.save(
            boundary.id,
            draft(boundary.scheduledDate, title: 'Fail split'),
            options(repeat: rule, scope: SeriesScope.future),
          ),
          throwsException,
        );
        final after = await store.forRange(first, last);
        expect(after.map((task) => task.id), before.map((task) => task.id));
        expect(after.first.isCompleted, isTrue);
        expect(await db.select(db.recurrenceRules).get(), hasLength(1));
        expect(
          await db.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
      },
    );

    test('recurring alarms use a rolling horizon and skip completed or deleted occurrences', () async {
      final gateway = FakeGateway();
      final due = first.add(const Duration(hours: 10));
      final scheduler = ReminderScheduler(store, gateway, clock: () => first);
      await store.save(
        null,
        draft(first, dueAt: due),
        options(
          repeat: RecurrenceRule(
            frequency: RecurrenceFrequency.daily,
            start: first,
          ),
          reminder: const ReminderDraft(minutesBefore: 10),
        ),
      );
      await scheduler.reconcile();
      expect(gateway.scheduled, hasLength(30));
      final tasks = await store.forRange(first, shiftDay(first, 1));
      await store.save(
        tasks.first.id,
        draft(first, title: 'Updated reminder title', dueAt: due),
        options(
          repeat: RecurrenceRule(
            frequency: RecurrenceFrequency.daily,
            start: first,
          ),
          reminder: const ReminderDraft(minutesBefore: 10),
          scope: SeriesScope.occurrence,
        ),
      );
      expect(await db.select(db.reminderRules).get(), hasLength(1));
      await store.toggle(tasks.first.id);
      await store.delete(tasks.last.id, SeriesScope.occurrence);
      await scheduler.reconcile();
      expect(
        gateway.scheduled.values.map((item) => item.taskId),
        isNot(contains(tasks.first.id)),
      );
      expect(
        gateway.scheduled.values.map((item) => item.taskId),
        isNot(contains(tasks.last.id)),
      );
      expect(gateway.scheduled, hasLength(28));
    });
  });

  test('analytics and combined search count occurrence records once per scheduled day', () {
    final now = DateTime(2045, 3, 3, 12);
    PlannerTask task(
      String id,
      int day, {
      bool complete = false,
      String? goal,
    }) => PlannerTask(
      id: id,
      title: 'Review   Plan',
      description: 'Quarterly notes',
      weeklyGoalId: goal,
      scheduledDate: DateTime(2045, 3, day),
      dueAt: DateTime(2045, 3, day, 10),
      isCompleted: complete,
      priority: TaskPriority.high,
      createdAt: now,
      updatedAt: now,
    );
    final tasks = [
      task('a', 1, complete: true),
      task('s~1234', 2, complete: true),
      task('b', 3, goal: 'w'),
    ];
    expect(completionStreak(tasks, dateOnly(now)), 2);
    expect(overdueCount(tasks, now), 1);
    expect(
      performanceBuckets(
        tasks,
        DateTime(2045, 3, 1),
        DateTime(2045, 3, 4),
      ).map((bucket) => bucket.completed),
      [1, 1, 0, 0],
    );
    expect(
      filterAndSortTasks(
        tasks,
        'quarterly   RELEASE',
        (
          status: SearchStatus.overdue,
          priority: TaskPriority.high,
          link: TaskLink.linked,
          recurring: false,
          sort: SearchSort.deadline,
          period: SearchPeriod.all,
          custom: null,
        ),
        now,
        {'w': 'Release milestone'},
      ).map((task) => task.id),
      ['b'],
    );
  });
}

class FakeGateway implements NotificationGateway {
  bool permission = true;
  bool failScheduling = false;
  String timezone = 'Africa/Addis_Ababa';
  int maxPending = 1000;
  int scheduleCalls = 0;
  final scheduled = <int, ({DateTime at, String taskId})>{};

  @override
  Future<bool> allowed() async => permission;
  @override
  Future<void> cancel(int id) async => scheduled.remove(id);
  @override
  Future<void> initialize(void Function(String) onTap) async {}
  @override
  Future<void> openSettings() async {}
  @override
  Future<Map<int, String>> pending() async => {
    for (final entry in scheduled.entries)
      entry.key: '$reminderPayloadPrefix${entry.value.taskId}',
  };
  @override
  Future<String> refreshTimezone() async => timezone;
  @override
  Future<bool> requestPermission() async => permission;
  @override
  Future<void> schedule(int id, DateTime utc, String taskId) async {
    if (failScheduling || scheduled.length >= maxPending) {
      throw StateError('Simulated platform failure or limit');
    }
    scheduleCalls++;
    scheduled[id] = (at: utc, taskId: taskId);
  }
}
