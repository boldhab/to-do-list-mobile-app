// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_goal_dao.dart';

// ignore_for_file: type=lint
mixin _$MonthlyGoalDaoMixin on DatabaseAccessor<AppDatabase> {
  $MonthlyGoalsTable get monthlyGoals => attachedDatabase.monthlyGoals;
  $WeeklyGoalsTable get weeklyGoals => attachedDatabase.weeklyGoals;
  MonthlyGoalDaoManager get managers => MonthlyGoalDaoManager(this);
}

class MonthlyGoalDaoManager {
  final _$MonthlyGoalDaoMixin _db;
  MonthlyGoalDaoManager(this._db);
  $$MonthlyGoalsTableTableManager get monthlyGoals =>
      $$MonthlyGoalsTableTableManager(_db.attachedDatabase, _db.monthlyGoals);
  $$WeeklyGoalsTableTableManager get weeklyGoals =>
      $$WeeklyGoalsTableTableManager(_db.attachedDatabase, _db.weeklyGoals);
}
