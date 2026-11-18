import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import 'daos/monthly_goal_dao.dart';
import 'daos/task_dao.dart';
import 'daos/weekly_goal_dao.dart';
import 'migrations/migration_strategy.dart';
import 'tables/monthly_goals_table.dart';
import 'tables/tasks_table.dart';
import 'tables/productivity_tables.dart';
import 'tables/weekly_goals_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MonthlyGoals,
    WeeklyGoals,
    Tasks,
    RecurrenceRules,
    OccurrenceStates,
    ReminderRules,
    ReminderDeliveries,
    ApplicationSettings,
  ],
  daos: [MonthlyGoalDao, WeeklyGoalDao, TaskDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.local() : this(driftDatabase(name: 'task_planner'));

  Future<void> dispose() async {
    try {
      await close();
    } catch (error) {
      // A lazy executor can repeat an earlier open error when closing.
      if (kDebugMode) {
        debugPrint('Planner database close failed (${error.runtimeType}).');
      }
    }
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => plannerMigration(this);
}
