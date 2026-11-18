import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_planner/core/database/app_database.dart';
import 'package:task_planner/core/database/database_provider.dart';
import 'package:task_planner/core/database/date_storage.dart';
import 'package:task_planner/core/errors/database_exception.dart';
import 'package:task_planner/core/errors/planner_exception.dart';
import 'package:task_planner/features/analytics/presentation/providers/progress_provider.dart';
import 'package:task_planner/features/planning/data/drift_planner_service.dart';
import 'package:task_planner/features/planning/domain/planner_commands.dart';
import 'package:task_planner/features/planning/domain/planner_snapshot.dart';
import 'package:task_planner/features/planning/presentation/planner_provider.dart';
import 'package:task_planner/features/tasks/domain/entities/task.dart';

final monday = DateTime(2024, 12, 30);
final deadline = DateTime.utc(2025, 1, 2, 22, 30, 4, 123);

Future<({String month, String week, String task})> createHierarchy(
  DriftPlannerService service,
) async {
  final month = await service.saveMonthly(
    title: 'January goal',
    description: 'Scope',
    year: 2025,
    month: 1,
    completed: false,
  );
  final week = await service.saveWeekly(
    title: 'Launch week',
    weekStart: monday,
    monthlyGoalId: month.id,
    completed: false,
  );
  final task = await service.saveTask(
    title: 'Launch',
    date: DateTime(2025, 1, 1),
    weeklyGoalId: week.id,
    priority: TaskPriority.high,
    completed: false,
    dueAt: deadline,
  );
  return (month: month.id, week: week.id, task: task.id);
}

ProviderContainer openPlanner(AppDatabase db) =>
    ProviderContainer(overrides: [appDatabaseProvider.overrideWithValue(db)]);

void main() {
  group('in-memory SQLite', () {
    late AppDatabase db;
    late ProviderContainer container;
    late DriftPlannerService service;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      container = openPlanner(db);
      service = container.read(driftPlannerServiceProvider);
    });

    tearDown(() async {
      container.dispose();
      await db.close();
    });

    test(
      'empty v2 schema has foreign keys and period and relationship indexes',
      () async {
        expect(await service.monthly.getAll(), isEmpty);
        expect(await service.weekly.getAll(), isEmpty);
        expect(await service.tasks.getAll(), isEmpty);
        expect(
          (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
            'user_version',
          ),
          2,
        );
        expect(
          (await db.customSelect('PRAGMA foreign_keys').getSingle()).read<int>(
            'foreign_keys',
          ),
          1,
        );
        final indexes = await db
            .customSelect("SELECT name FROM sqlite_master WHERE type = 'index'")
            .get();
        expect(
          indexes.map((row) => row.read<String>('name')),
          containsAll([
            'monthly_goals_period',
            'weekly_goals_parent',
            'weekly_goals_period',
            'tasks_parent',
            'tasks_scheduled',
            'tasks_deadline',
          ]),
        );
      },
    );

    test(
      'SQLite rejects invalid relationships, duplicate IDs and invalid columns',
      () async {
        final ids = await createHierarchy(service);
        final now = DateTime.now().toUtc();
        final weekly = WeeklyGoalsCompanion.insert(
          id: 'bad',
          monthlyGoalId: const Value('missing'),
          title: 'Invalid',
          weekStart: encodeDay(monday),
          weekEnd: encodeDay(DateTime(2025, 1, 5)),
          createdAt: now,
          updatedAt: now,
        );
        await expectLater(db.weeklyGoalDao.insertRow(weekly), throwsException);
        await expectLater(
          db.weeklyGoalDao.insertRow(
            weekly.copyWith(
              monthlyGoalId: const Value(null),
              weekStart: Value(encodeDay(DateTime(2025, 1, 1))),
            ),
          ),
          throwsException,
        );
        final task = TasksCompanion.insert(
          id: 'invalid',
          weeklyGoalId: const Value('missing'),
          title: 'Task',
          scheduledDate: encodeDay(DateTime(2025, 1, 1)),
          priority: 'high',
          createdAt: now,
          updatedAt: now,
        );
        await expectLater(db.taskDao.insertRow(task), throwsException);
        await expectLater(
          db.taskDao.insertRow(
            task.copyWith(
              weeklyGoalId: const Value(null),
              priority: const Value('unknown'),
            ),
          ),
          throwsException,
        );
        await expectLater(
          db.taskDao.insertRow(
            task.copyWith(
              weeklyGoalId: const Value(null),
              isCompleted: const Value(true),
            ),
          ),
          throwsException,
        );
        await expectLater(
          db.monthlyGoalDao.insertRow(
            MonthlyGoalsCompanion.insert(
              id: 'invalid',
              title: ' ',
              year: 2025,
              month: 13,
              createdAt: now,
              updatedAt: now,
            ),
          ),
          throwsException,
        );
        await expectLater(
          db.monthlyGoalDao.deleteRow(ids.month),
          throwsException,
        );
        await expectLater(
          db.weeklyGoalDao.deleteRow(ids.week),
          throwsException,
        );
        await expectLater(
          service.tasks.create((await service.tasks.getById(ids.task))!),
          throwsA(isA<PlannerDatabaseException>()),
        );
        expect(await service.tasks.getAll(), hasLength(1));
      },
    );

    test(
      'indexed periods handle leap days, pre-epoch days and year boundaries',
      () async {
        final ids = await createHierarchy(service);
        for (final date in [
          DateTime(1969, 12, 31),
          DateTime(2024, 2, 29),
          monday,
          DateTime(2025, 1, 6),
        ]) {
          await service.saveTask(
            title: 'Standalone',
            date: date,
            priority: TaskPriority.low,
            completed: false,
          );
          expect(
            (await db.taskDao.onDay(date)).single.scheduledDate,
            encodeDay(date),
          );
        }
        expect(
          decodeDay(encodeDay(DateTime.utc(1969, 12, 31, 23))),
          DateTime(1969, 12, 31),
        );
        expect(
          (await db.taskDao.inWeek(DateTime(2025, 1, 4))).map((row) => row.id),
          contains(ids.task),
        );
        expect(await db.taskDao.inWeek(DateTime(2025, 1, 4)), hasLength(2));
        expect(await db.taskDao.inMonth(2024, 12), hasLength(1));
        expect(await db.taskDao.inMonth(2025, 1), hasLength(2));
        expect((await db.monthlyGoalDao.inMonth(2025, 1)).single.id, ids.month);
        expect((await db.weeklyGoalDao.inWeek(monday)).single.id, ids.week);
        expect(
          (await db.monthlyGoalDao.weeklyChildren(ids.month)).single.id,
          ids.week,
        );
        expect(
          (await service.tasks.getBetween(
            DateTime(2025, 1, 1, 23),
            DateTime(2025, 1, 1),
          )).single.id,
          ids.task,
        );
      },
    );

    test('edits, completion, reassignment and schedule changes survive repository reads', () async {
      final ids = await createHierarchy(service);
      final newMonth = await service.saveMonthly(
        title: 'New parent',
        year: 2025,
        month: 2,
        completed: false,
      );
      await service.saveMonthly(
        id: ids.month,
        title: 'Revised',
        year: 2025,
        month: 1,
        completed: true,
      );
      expect((await service.monthly.getById(ids.month))!.isCompleted, isTrue);
      await service.saveWeekly(
        id: ids.week,
        title: 'Revised week',
        weekStart: monday,
        monthlyGoalId: newMonth.id,
        completed: true,
      );
      expect(
        (await service.weekly.getById(ids.week))!.monthlyGoalId,
        newMonth.id,
      );
      await expectLater(
        service.saveTask(
          id: ids.task,
          title: 'Out of range',
          date: DateTime(2025, 1, 6),
          weeklyGoalId: ids.week,
          priority: TaskPriority.high,
          completed: false,
        ),
        throwsA(isA<PlannerException>()),
      );
      await expectLater(
        service.saveWeekly(
          id: ids.week,
          title: 'Move',
          weekStart: DateTime(2025, 1, 6),
          monthlyGoalId: newMonth.id,
          completed: false,
        ),
        throwsA(isA<PlannerException>()),
      );
      await service.saveWeekly(
        id: ids.week,
        title: 'Move',
        weekStart: DateTime(2025, 1, 6),
        monthlyGoalId: newMonth.id,
        completed: false,
        move: WeekMovePolicy.reschedule,
      );
      expect(
        (await service.tasks.getById(ids.task))!.scheduledDate,
        DateTime(2025, 1, 8),
      );
      await service.toggleTask(ids.task);
      final completed = (await service.tasks.getById(ids.task))!;
      expect(completed.completedAt, isNotNull);
      expect(completed.dueAt!.toUtc(), deadline);
      expect((await db.taskDao.byCompletion(true)).single.id, ids.task);
      await service.toggleTask(ids.task);
      expect((await service.tasks.getById(ids.task))!.completedAt, isNull);
      await service.saveWeekly(
        id: ids.week,
        title: 'Move again',
        weekStart: monday,
        completed: false,
        move: WeekMovePolicy.unlink,
      );
      expect((await service.weekly.getById(ids.week))!.monthlyGoalId, isNull);
      expect((await service.tasks.getById(ids.task))!.weeklyGoalId, isNull);
      expect(
        (await service.tasks.getById(ids.task))!.scheduledDate,
        DateTime(2025, 1, 8),
      );
      await service.deleteTask(ids.task);
      expect(await service.tasks.getAll(), isEmpty);
    });

    for (final policy in DeletePolicy.values) {
      test(
        'monthly deletion with ${policy.name} preserves unrelated tasks',
        () async {
          final ids = await createHierarchy(service);
          final other = await service.saveTask(
            title: 'Other',
            date: monday,
            priority: TaskPriority.low,
            completed: false,
          );
          await service.deleteMonthly(ids.month, policy);
          expect(await service.monthly.getAll(), isEmpty);
          expect(await service.tasks.getById(other.id), isNotNull);
          if (policy == DeletePolicy.preserve) {
            expect(
              (await service.weekly.getById(ids.week))!.monthlyGoalId,
              isNull,
            );
            expect(
              (await service.tasks.getById(ids.task))!.weeklyGoalId,
              ids.week,
            );
          } else {
            expect(await service.weekly.getAll(), isEmpty);
            expect(await service.tasks.getById(ids.task), isNull);
          }
        },
      );

      test(
        'weekly deletion with ${policy.name} preserves the parent',
        () async {
          final ids = await createHierarchy(service);
          await service.deleteWeekly(ids.week, policy);
          expect(await service.weekly.getAll(), isEmpty);
          expect(await service.monthly.getById(ids.month), isNotNull);
          final child = await service.tasks.getById(ids.task);
          if (policy == DeletePolicy.preserve) {
            expect(child, isNotNull);
            expect(child!.weeklyGoalId, isNull);
          } else {
            expect(child, isNull);
          }
        },
      );
    }

    test(
      'failed parent delete rolls back changes and emits no partial hierarchy',
      () async {
        final ids = await createHierarchy(service);
        final snapshots = <PlannerSnapshot>[];
        final initial = Completer<void>();
        final subscription = service.watchAll().listen((value) {
          snapshots.add(value);
          if (!initial.isCompleted) initial.complete();
        });
        addTearDown(subscription.cancel);
        await initial.future;
        await db.customStatement("""
      CREATE TRIGGER block_delete BEFORE DELETE ON monthly_goals
      BEGIN SELECT RAISE(ABORT, 'forced failure'); END
    """);
        for (final policy in DeletePolicy.values) {
          await expectLater(
            service.deleteMonthly(ids.month, policy),
            throwsA(isA<PlannerDatabaseException>()),
          );
          expect(
            (await service.weekly.getById(ids.week))!.monthlyGoalId,
            ids.month,
          );
          expect(
            (await service.tasks.getById(ids.task))!.weeklyGoalId,
            ids.week,
          );
        }
        expect(snapshots, hasLength(1));
      },
    );

    test(
      'Drift streams refresh Riverpod progress only after committed mutations',
      () async {
        final progress = <int>[];
        final range = (start: monday, end: DateTime(2025, 1, 5));
        final observed = Completer<void>();
        final listener = container.listen(periodProgressProvider(range), (
          _,
          next,
        ) {
          progress.add(next.percentage);
          if (next.percentage == 100) observed.complete();
        }, fireImmediately: true);
        addTearDown(listener.close);
        final ids = await createHierarchy(service);
        final goalObserved = Completer<void>();
        final goalListener = container.listen(
          monthlyGoalProgressProvider(ids.month),
          (_, next) {
            if (next.percentage == 100 && !goalObserved.isCompleted) {
              goalObserved.complete();
            }
          },
          fireImmediately: true,
        );
        addTearDown(goalListener.close);
        await service.toggleTask(ids.task);
        await Future.wait([observed.future, goalObserved.future])
            .timeout(const Duration(seconds: 5));
        expect(progress, [0, 100]);
        expect(
          container.read(monthlyGoalProgressProvider(ids.month)).percentage,
          100,
        );
        final deleted = service.watchAll().firstWhere(
          (state) => state.monthly.isEmpty,
        );
        await service.deleteMonthly(ids.month, DeletePolicy.cascade);
        final after = await deleted.timeout(const Duration(seconds: 5));
        expect(after.weekly, isEmpty);
        expect(after.tasks, isEmpty);
      },
    );

    test('date stream stays scoped over a thousand rows', () async {
      final now = DateTime.now().toUtc();
      await db.batch(
        (batch) => batch.insertAll(db.tasks, [
          for (var day = 0; day < 1000; day++)
            TasksCompanion.insert(
              id: 'fixture-$day',
              title: 'Fixture $day',
              scheduledDate: day,
              priority: 'medium',
              createdAt: now,
              updatedAt: now,
            ),
        ]),
      );
      final query = service.tasks.watchBetween(decodeDay(500), decodeDay(500));
      expect((await query.first).single.id, 'fixture-500');
      final updates = query.take(2).toList();
      await service.toggleTask('fixture-500');
      final states = await updates.timeout(const Duration(seconds: 5));
      expect(states.map((state) => state.single.isCompleted), [false, true]);
    });
  });

  test('unsupported schema downgrade leaves data and version intact', () async {
    final directory = await Directory.systemTemp.createTemp(
      'planner-version-test-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/future.sqlite');
    final newer = FutureVersionDatabase(NativeDatabase(file));
    final newerContainer = openPlanner(newer);
    final ids = await createHierarchy(
      newerContainer.read(driftPlannerServiceProvider),
    );
    newerContainer.dispose();
    await newer.close();

    final older = AppDatabase(NativeDatabase(file));
    await expectLater(
      older.monthlyGoalDao.all(),
      throwsA(isA<UnsupportedError>()),
    );
    await older.close();

    final reopened = FutureVersionDatabase(NativeDatabase(file));
    addTearDown(reopened.close);
    expect(
      (await reopened.customSelect('PRAGMA user_version').getSingle())
          .read<int>('user_version'),
      3,
    );
    expect(
      (await reopened.weeklyGoalDao.byId(ids.week))!.monthlyGoalId,
      ids.month,
    );
    expect((await reopened.taskDao.byId(ids.task))!.weeklyGoalId, ids.week);
  });

  test(
    'all three levels reopen from a file with the same IDs and timestamps',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'task-planner-test-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/planner.sqlite');
      final first = AppDatabase(NativeDatabase(file));
      final firstContainer = openPlanner(first);
      final firstService = firstContainer.read(driftPlannerServiceProvider);
      final ids = await createHierarchy(firstService);
      await firstService.toggleTask(ids.task);
      final original = await firstService.tasks.getById(ids.task);
      firstContainer.dispose();
      await first.close();

      final reopened = AppDatabase(NativeDatabase(file));
      addTearDown(reopened.close);
      final reopenedContainer = openPlanner(reopened);
      addTearDown(reopenedContainer.dispose);
      final secondService = reopenedContainer.read(driftPlannerServiceProvider);
      final reloaded = await secondService.watchAll().first;
      expect(reloaded.monthly.single.id, ids.month);
      expect(reloaded.weekly.single.monthlyGoalId, ids.month);
      expect(reloaded.tasks.single, original);
      expect(reloaded.tasks.single.weeklyGoalId, ids.week);
      expect(reloaded.tasks.single.completedAt, isNotNull);
      expect(reloaded.tasks.single.dueAt!.toUtc(), deadline);
      expect(
        (await reopened.customSelect('PRAGMA foreign_keys').getSingle())
            .read<int>('foreign_keys'),
        1,
      );
      final additional = await secondService.saveTask(
        title: 'New',
        date: monday,
        priority: TaskPriority.low,
        completed: false,
      );
      expect(additional.id, isNot(ids.task));
    },
  );
}

class FutureVersionDatabase extends AppDatabase {
  FutureVersionDatabase(super.executor);

  @override
  int get schemaVersion => 3;
}
