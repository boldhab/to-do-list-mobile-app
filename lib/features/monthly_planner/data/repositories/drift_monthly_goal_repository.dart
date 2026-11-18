import '../../../../core/database/daos/monthly_goal_dao.dart';
import '../../../../core/database/mappers/monthly_goal_mapper.dart';
import '../../../../core/errors/database_exception.dart';
import '../../../../core/errors/planner_exception.dart';
import '../../domain/entities/monthly_goal.dart';
import '../../domain/repositories/monthly_goal_repository.dart';
import '../../../planning/domain/planner_snapshot.dart';

class DriftMonthlyGoalRepository implements MonthlyGoalRepository {
  DriftMonthlyGoalRepository(this.dao);

  final MonthlyGoalDao dao;

  @override
  Future<List<MonthlyGoal>> getAll() => databaseOperation(
    'load monthly_goal',
    () async => (await dao.all()).map(monthlyGoalFromRow).toList(),
  );

  @override
  Future<MonthlyGoal?> getById(String id) =>
      databaseOperation('load monthly_goal', () async {
        final row = await dao.byId(id);
        return row == null ? null : monthlyGoalFromRow(row);
      });

  @override
  Stream<List<MonthlyGoal>> watchAll() =>
      dao.watchAll().map((rows) => rows.map(monthlyGoalFromRow).toList());

  @override
  Future<void> create(MonthlyGoal entity) => databaseOperation(
    'create monthly_goal',
    () => dao.attachedDatabase.transaction(() async {
      PlannerSnapshot(monthly: [entity]).validate();
      await dao.insertRow(monthlyGoalToRow(entity));
    }),
  );

  @override
  Future<void> update(MonthlyGoal entity) => databaseOperation(
    'update monthly_goal',
    () => dao.attachedDatabase.transaction(() async {
      PlannerSnapshot(monthly: [entity]).validate();
      if (await dao.updateRow(entity.id, monthlyGoalToRow(entity)) == 0) {
        throw PlannerException('This item no longer exists.');
      }
    }),
  );

  @override
  Future<void> delete(String id) =>
      databaseOperation('delete monthly_goal', () async {
        if (await dao.deleteRow(id) == 0) {
          throw PlannerException('This item no longer exists.');
        }
      });
}
