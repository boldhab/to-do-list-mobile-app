import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/weekly_goals_table.dart';
import '../date_storage.dart';

part 'weekly_goal_dao.g.dart';

@DriftAccessor(tables: [WeeklyGoals])
class WeeklyGoalDao extends DatabaseAccessor<AppDatabase>
    with _$WeeklyGoalDaoMixin {
  WeeklyGoalDao(super.attachedDatabase);

  SimpleSelectStatement<$WeeklyGoalsTable, WeeklyGoalRow> _ordered() =>
      select(weeklyGoals)..orderBy([(row) => OrderingTerm.asc(row.id)]);

  Future<List<WeeklyGoalRow>> all() => _ordered().get();
  Stream<List<WeeklyGoalRow>> watchAll() => _ordered().watch();
  Future<WeeklyGoalRow?> byId(String id) => (select(
    weeklyGoals,
  )..where((row) => row.id.equals(id))).getSingleOrNull();
  Future<int> insertRow(WeeklyGoalsCompanion row) =>
      into(weeklyGoals).insert(row);
  Future<int> updateRow(String id, WeeklyGoalsCompanion row) => (update(
    weeklyGoals,
  )..where((existing) => existing.id.equals(id))).write(row);
  Future<int> deleteRow(String id) =>
      (delete(weeklyGoals)..where((row) => row.id.equals(id))).go();

  Future<List<WeeklyGoalRow>> inWeek(DateTime start) => (select(
    weeklyGoals,
  )..where((row) => row.weekStart.equals(encodeDay(start)))).get();

  Future<List<WeeklyGoalRow>> byMonthlyGoal(String id) =>
      (select(weeklyGoals)..where((row) => row.monthlyGoalId.equals(id))).get();

  Future<int> unlinkMonthlyGoal(String id, DateTime changed) =>
      (update(weeklyGoals)..where((row) => row.monthlyGoalId.equals(id))).write(
        WeeklyGoalsCompanion(
          monthlyGoalId: const Value(null),
          updatedAt: Value(changed),
        ),
      );

  Future<void> setParent(String id, String? parent, DateTime changed) async {
    await (update(weeklyGoals)..where((row) => row.id.equals(id))).write(
      WeeklyGoalsCompanion(
        monthlyGoalId: Value(parent),
        updatedAt: Value(changed),
      ),
    );
  }
}
