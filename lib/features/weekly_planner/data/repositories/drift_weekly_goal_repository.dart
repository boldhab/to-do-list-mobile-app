import '../../../../core/database/daos/weekly_goal_dao.dart';
import '../../../../core/database/mappers/weekly_goal_mapper.dart';
import '../../../../core/errors/database_exception.dart';
import '../../../../core/errors/planner_exception.dart';
import '../../../../core/database/daos/monthly_goal_dao.dart';
import '../../../../core/database/daos/task_dao.dart';
import '../../../../core/database/mappers/monthly_goal_mapper.dart';
import '../../../../core/database/mappers/task_mapper.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../domain/entities/weekly_goal.dart';
import '../../domain/repositories/weekly_goal_repository.dart';
import '../../../planning/domain/planner_snapshot.dart';

class DriftWeeklyGoalRepository implements WeeklyGoalRepository {
  DriftWeeklyGoalRepository(this.dao, this.monthly, this.tasks);

  final WeeklyGoalDao dao;
  final MonthlyGoalDao monthly;
  final TaskDao tasks;

  @override
  Future<List<WeeklyGoal>> getAll() => databaseOperation(
    'load weekly_goal',
    () async => (await dao.all()).map(weeklyGoalFromRow).toList(),
  );

  @override
  Future<WeeklyGoal?> getById(String id) =>
      databaseOperation('load weekly_goal', () async {
        final row = await dao.byId(id);
        return row == null ? null : weeklyGoalFromRow(row);
      });

  @override
  Stream<List<WeeklyGoal>> watchAll() =>
      dao.watchAll().map((rows) => rows.map(weeklyGoalFromRow).toList());

  @override
  Future<void> create(WeeklyGoal entity) => databaseOperation(
    'create weekly_goal',
    () => dao.attachedDatabase.transaction(() async {
      await _validate(entity);
      await dao.insertRow(weeklyGoalToRow(entity));
    }),
  );

  @override
  Future<void> update(WeeklyGoal entity) => databaseOperation(
    'update weekly_goal',
    () => dao.attachedDatabase.transaction(() async {
      await _validate(entity);
      if (await dao.updateRow(entity.id, weeklyGoalToRow(entity)) == 0) {
        throw PlannerException('This item no longer exists.');
      }
    }),
  );

  @override
  Future<void> delete(String id) =>
      databaseOperation('delete weekly_goal', () async {
        if (await dao.deleteRow(id) == 0) {
          throw PlannerException('This item no longer exists.');
        }
      });

  Future<void> _validate(WeeklyGoal entity) async {
    final parent = entity.monthlyGoalId == null
        ? null
        : await monthly.byId(entity.monthlyGoalId!);
    final children = await tasks.byWeeklyGoal(entity.id);
    PlannerSnapshot(
      monthly: [if (parent != null) monthlyGoalFromRow(parent)],
      weekly: [entity],
      tasks: children.map(taskFromRow),
    ).validate();
  }

  Future<void> moveWithTasks(WeeklyGoal entity, List<PlannerTask> children) =>
      databaseOperation(
        'move weekly goal',
        () => dao.attachedDatabase.transaction(() async {
          final existingIds = (await tasks.byWeeklyGoal(entity.id))
              .map((task) => task.id)
              .toSet();
          final requestedIds = children.map((task) => task.id).toSet();
          if (existingIds.length != requestedIds.length ||
              !existingIds.containsAll(requestedIds) ||
              children.any(
                (task) =>
                    task.weeklyGoalId != null && task.weeklyGoalId != entity.id,
              )) {
            throw PlannerException(
              'The linked tasks changed. Review the week and try again.',
            );
          }
          final parent = entity.monthlyGoalId == null
              ? null
              : await monthly.byId(entity.monthlyGoalId!);
          PlannerSnapshot(
            monthly: [if (parent != null) monthlyGoalFromRow(parent)],
            weekly: [entity],
            tasks: children,
          ).validate();
          if (await dao.updateRow(entity.id, weeklyGoalToRow(entity)) == 0) {
            throw PlannerException('This weekly goal no longer exists.');
          }
          for (final child in children) {
            if (await tasks.updateRow(child.id, taskToRow(child)) == 0) {
              throw PlannerException('A linked task no longer exists.');
            }
          }
        }),
      );
  Future<List<WeeklyGoal>> forMonthlyGoal(String id) async =>
      (await dao.byMonthlyGoal(id)).map(weeklyGoalFromRow).toList();

  Future<int> unlinkMonthlyGoal(String id, DateTime changed) =>
      dao.unlinkMonthlyGoal(id, changed);
}
