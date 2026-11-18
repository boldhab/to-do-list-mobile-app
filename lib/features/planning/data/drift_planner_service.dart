import 'dart:math';

import 'package:flutter/foundation.dart' show listEquals;

import '../../../core/database/app_database.dart';
import '../../../core/errors/database_exception.dart';
import '../../../core/errors/planner_exception.dart';
import '../../../core/utils/date_helpers.dart';
import '../../monthly_planner/data/repositories/drift_monthly_goal_repository.dart';
import '../../monthly_planner/domain/entities/monthly_goal.dart';
import '../../tasks/data/repositories/drift_task_repository.dart';
import '../../tasks/domain/entities/task.dart';
import '../../weekly_planner/data/repositories/drift_weekly_goal_repository.dart';
import '../../weekly_planner/domain/entities/weekly_goal.dart';
import '../domain/planner_commands.dart';
import '../domain/planner_snapshot.dart';
import '../domain/validation.dart';

class DriftPlannerService implements PlannerCommands {
  DriftPlannerService(this.database, this.monthly, this.weekly, this.tasks);

  final AppDatabase database;
  final DriftMonthlyGoalRepository monthly;
  final DriftWeeklyGoalRepository weekly;
  final DriftTaskRepository tasks;
  final _random = Random.secure();

  String _id(String prefix) {
    final suffix = List.generate(
      16,
      (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    return '$prefix-$suffix';
  }

  T _require<T>(T? value, String label) =>
      value ?? (throw PlannerException('This $label no longer exists.'));

  Future<T> _transaction<T>(String operation, Future<T> Function() action) =>
      databaseOperation(operation, () => database.transaction(action));

  Stream<PlannerSnapshot> watchAll({bool includeTasks = true}) async* {
    // Open explicitly so initialization failures are delivered as stream errors
    // before Drift starts watching query invalidations.
    await databaseOperation(
      'open planner',
      () => database.customSelect('SELECT 1').getSingle(),
    );
    yield* database
        .customSelect(
          includeTasks
              ? 'SELECT 1 /* planner all */'
              : 'SELECT 1 /* planner goals */',
          readsFrom: {
            database.monthlyGoals,
            database.weeklyGoals,
            if (includeTasks) database.tasks,
          },
        )
        .watch()
        .asyncMap(
          (_) => _transaction(
            'load planner',
            () async => PlannerSnapshot(
              monthly: await monthly.getAll(),
              weekly: await weekly.getAll(),
              tasks: includeTasks ? await tasks.getAll() : const [],
            ),
          ),
        )
        .distinct(
          (a, b) =>
              listEquals(a.monthly, b.monthly) &&
              listEquals(a.weekly, b.weekly) &&
              listEquals(a.tasks, b.tasks),
        );
  }

  @override
  Future<MonthlyGoal> saveMonthly({
    String? id,
    required String title,
    String? description,
    required int year,
    required int month,
    required bool completed,
  }) => _transaction('save monthly goal', () async {
    final now = DateTime.now();
    final old = id == null
        ? null
        : _require(await monthly.getById(id), 'monthly goal');
    final goal = MonthlyGoal(
      id: old?.id ?? _id('month'),
      title: validatedTitle(title),
      description: cleanDescription(description),
      year: year,
      month: month,
      isCompleted: completed,
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
    );
    if (old == null) {
      await monthly.create(goal);
    } else {
      await monthly.update(goal);
    }
    return goal;
  });

  @override
  Future<WeeklyGoal> saveWeekly({
    String? id,
    required String title,
    String? description,
    required DateTime weekStart,
    String? monthlyGoalId,
    required bool completed,
    WeekMovePolicy? move,
  }) => _transaction('save weekly goal', () async {
    final now = DateTime.now();
    final old = id == null
        ? null
        : _require(await weekly.getById(id), 'weekly goal');
    final goal = WeeklyGoal(
      id: old?.id ?? _id('week'),
      title: validatedTitle(title),
      description: cleanDescription(description),
      weekStart: dateOnly(weekStart),
      weekEnd: shiftDay(weekStart, 6),
      monthlyGoalId: monthlyGoalId,
      isCompleted: completed,
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
    );
    if (old == null) {
      await weekly.create(goal);
      return goal;
    }
    if (old.weekStart == goal.weekStart) {
      await weekly.update(goal);
      return goal;
    }
    final children = await tasks.forWeeklyGoal(goal.id);
    if (children.isEmpty) {
      await weekly.update(goal);
      return goal;
    }
    if (move == null) {
      throw PlannerException(
        'Choose how to handle tasks outside the new week.',
      );
    }
    await weekly.moveWithTasks(goal, [
      for (final task in children)
        switch (move) {
          WeekMovePolicy.unlink => task.copyWith(
            clearWeeklyGoal: true,
            updatedAt: now,
          ),
          WeekMovePolicy.reschedule => task.copyWith(
            scheduledDate: shiftDay(
              goal.weekStart,
              task.scheduledDate.weekday - 1,
            ),
            updatedAt: now,
          ),
        },
    ]);
    return goal;
  });

  @override
  Future<PlannerTask> saveTask({
    String? id,
    required String title,
    String? description,
    required DateTime date,
    DateTime? dueAt,
    String? weeklyGoalId,
    required TaskPriority priority,
    required bool completed,
  }) => _transaction('save task', () async {
    final old = id == null ? null : _require(await tasks.getById(id), 'task');
    final now = DateTime.now();
    final task = PlannerTask(
      id: old?.id ?? _id('task'),
      title: validatedTitle(title),
      description: cleanDescription(description),
      scheduledDate: dateOnly(date),
      dueAt: dueAt,
      weeklyGoalId: weeklyGoalId,
      priority: priority,
      isCompleted: completed,
      completedAt: completed ? old?.completedAt ?? now : null,
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
    );
    if (old == null) {
      await tasks.create(task);
    } else {
      await tasks.update(task);
    }
    return task;
  });

  @override
  Future<void> deleteTask(String id) => tasks.delete(id);

  @override
  Future<void> toggleTask(String id) => _transaction(
    'update task completion',
    () async {
      final task = _require(await tasks.getById(id), 'task');
      await tasks.setCompletion(id, !task.isCompleted, DateTime.now().toUtc());
    },
  );

  @override
  Future<void> toggleMonthly(String id) =>
      _transaction('update monthly goal', () async {
        final goal = _require(await monthly.getById(id), 'monthly goal');
        await monthly.update(
          goal.copyWith(
            isCompleted: !goal.isCompleted,
            updatedAt: DateTime.now(),
          ),
        );
      });

  @override
  Future<void> toggleWeekly(String id) =>
      _transaction('update weekly goal', () async {
        final goal = _require(await weekly.getById(id), 'weekly goal');
        await weekly.update(
          goal.copyWith(
            isCompleted: !goal.isCompleted,
            updatedAt: DateTime.now(),
          ),
        );
      });

  @override
  Future<void> deleteMonthly(String id, DeletePolicy policy) =>
      _transaction('delete monthly goal', () async {
        _require(await monthly.getById(id), 'monthly goal');
        final now = DateTime.now().toUtc();
        if (policy == DeletePolicy.preserve) {
          await weekly.unlinkMonthlyGoal(id, now);
        } else {
          final children = await weekly.forMonthlyGoal(id);
          for (final row in children) {
            await _removeWeekly(row.id, policy, now);
          }
        }
        await monthly.delete(id);
      });

  @override
  Future<void> deleteWeekly(String id, DeletePolicy policy) =>
      _transaction('delete weekly goal', () async {
        _require(await weekly.getById(id), 'weekly goal');
        await _removeWeekly(id, policy, DateTime.now().toUtc());
      });

  Future<void> _removeWeekly(
    String id,
    DeletePolicy policy,
    DateTime now,
  ) async {
    if (policy == DeletePolicy.cascade) {
      await tasks.deleteByWeeklyGoal(id);
    } else {
      await tasks.unlinkWeeklyGoal(id, now);
    }
    await weekly.delete(id);
  }
}
