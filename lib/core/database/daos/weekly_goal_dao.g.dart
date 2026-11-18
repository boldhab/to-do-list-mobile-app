// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_goal_dao.dart';

// ignore_for_file: type=lint
mixin _$WeeklyGoalDaoMixin on DatabaseAccessor<AppDatabase> {
  $MonthlyGoalsTable get monthlyGoals => attachedDatabase.monthlyGoals;
  $WeeklyGoalsTable get weeklyGoals => attachedDatabase.weeklyGoals;
  WeeklyGoalDaoManager get managers => WeeklyGoalDaoManager(this);
}

class WeeklyGoalDaoManager {
  final _$WeeklyGoalDaoMixin _db;
  WeeklyGoalDaoManager(this._db);
  $$MonthlyGoalsTableTableManager get monthlyGoals =>
      $$MonthlyGoalsTableTableManager(_db.attachedDatabase, _db.monthlyGoals);
  $$WeeklyGoalsTableTableManager get weeklyGoals =>
      $$WeeklyGoalsTableTableManager(_db.attachedDatabase, _db.weeklyGoals);
}
