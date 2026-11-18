import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/monthly_planner/data/repositories/drift_monthly_goal_repository.dart';
import '../../features/tasks/data/repositories/drift_task_repository.dart';
import '../../features/weekly_planner/data/repositories/drift_weekly_goal_repository.dart';
import 'app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.local();
  ref.onDispose(() => unawaited(database.dispose()));
  return database;
});

final monthlyRepositoryProvider = Provider<DriftMonthlyGoalRepository>(
  (ref) =>
      DriftMonthlyGoalRepository(ref.watch(appDatabaseProvider).monthlyGoalDao),
);

final weeklyRepositoryProvider = Provider<DriftWeeklyGoalRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftWeeklyGoalRepository(
    database.weeklyGoalDao,
    database.monthlyGoalDao,
    database.taskDao,
  );
});

final taskRepositoryProvider = Provider<DriftTaskRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftTaskRepository(database.taskDao, database.weeklyGoalDao);
});
