import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/monthly_goals_table.dart';
import '../tables/weekly_goals_table.dart';

part 'monthly_goal_dao.g.dart';

@DriftAccessor(tables: [MonthlyGoals, WeeklyGoals])
class MonthlyGoalDao extends DatabaseAccessor<AppDatabase>
    with _$MonthlyGoalDaoMixin {
  MonthlyGoalDao(super.attachedDatabase);

  SimpleSelectStatement<$MonthlyGoalsTable, MonthlyGoalRow> _ordered() =>
      select(monthlyGoals)..orderBy([(row) => OrderingTerm.asc(row.id)]);

  Future<List<MonthlyGoalRow>> all() => _ordered().get();
  Stream<List<MonthlyGoalRow>> watchAll() => _ordered().watch();
  Future<MonthlyGoalRow?> byId(String id) => (select(
    monthlyGoals,
  )..where((row) => row.id.equals(id))).getSingleOrNull();
  Future<int> insertRow(MonthlyGoalsCompanion row) =>
      into(monthlyGoals).insert(row);
  Future<int> updateRow(String id, MonthlyGoalsCompanion row) => (update(
    monthlyGoals,
  )..where((existing) => existing.id.equals(id))).write(row);
  Future<int> deleteRow(String id) =>
      (delete(monthlyGoals)..where((row) => row.id.equals(id))).go();

  Future<List<MonthlyGoalRow>> inMonth(int year, int month) => (select(
    monthlyGoals,
  )..where((row) => row.year.equals(year) & row.month.equals(month))).get();

  Future<List<WeeklyGoalRow>> weeklyChildren(String id) =>
      (select(weeklyGoals)..where((row) => row.monthlyGoalId.equals(id))).get();
}
