import 'package:flutter/foundation.dart' show listEquals;

import '../../../../core/database/app_database.dart' show TaskRow;
import '../../../../core/database/daos/task_dao.dart';
import '../../../../core/database/mappers/task_mapper.dart';
import '../../../../core/errors/database_exception.dart';
import '../../../../core/errors/planner_exception.dart';
import '../../../../core/database/daos/weekly_goal_dao.dart';
import '../../../../core/database/mappers/weekly_goal_mapper.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../planning/domain/validation.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this.dao, this.weekly);

  final TaskDao dao;
  final WeeklyGoalDao weekly;

  @override
  Future<List<PlannerTask>> getAll() => databaseOperation(
    'load task',
    () async => (await dao.all()).map(taskFromRow).toList(),
  );

  @override
  Future<PlannerTask?> getById(String id) =>
      databaseOperation('load task', () async {
        final row = await dao.byId(id);
        return row == null ? null : taskFromRow(row);
      });

  @override
  Stream<List<PlannerTask>> watchAll() =>
      dao.watchAll().map((rows) => rows.map(taskFromRow).toList());

  @override
  Future<void> create(PlannerTask entity) => databaseOperation(
    'create task',
    () => dao.attachedDatabase.transaction(() async {
      await _validate(entity);
      await dao.insertRow(taskToRow(entity));
    }),
  );

  @override
  Future<void> update(PlannerTask entity) => databaseOperation(
    'update task',
    () => dao.attachedDatabase.transaction(() async {
      await _validate(entity);
      if (await dao.updateRow(entity.id, taskToRow(entity)) == 0) {
        throw PlannerException('This item no longer exists.');
      }
    }),
  );

  @override
  Future<void> delete(String id) => databaseOperation('delete task', () async {
    if (await dao.deleteRow(id) == 0) {
      throw PlannerException('This item no longer exists.');
    }
  });

  Future<void> _validate(PlannerTask entity) async {
    validateYear(entity.scheduledDate.year);
    if (entity.dueAt case final deadline?) validateYear(deadline.year);
    validatedTitle(entity.title);
    if (entity.id.trim().isEmpty) {
      throw PlannerException('A task identifier is required.');
    }
    if (entity.isCompleted != (entity.completedAt != null)) {
      throw PlannerException(
        'Task completion requires a consistent timestamp.',
      );
    }
    if (entity.weeklyGoalId case final parentId?) {
      final row = await weekly.byId(parentId);
      if (row == null) {
        throw PlannerException('The selected weekly goal no longer exists.');
      }
      final parent = weeklyGoalFromRow(row);
      if (!dateInRange(
        entity.scheduledDate,
        parent.weekStart,
        parent.weekEnd,
      )) {
        throw PlannerException(
          'Schedule the task within the selected goal’s week or unlink it.',
        );
      }
    }
  }

  @override
  Future<List<PlannerTask>> getBetween(DateTime start, DateTime end) =>
      databaseOperation(
        'query tasks by date',
        () async => (await dao.between(start, end)).map(taskFromRow).toList(),
      );
  Stream<List<PlannerTask>> watchBetween(DateTime start, DateTime end) =>
      dao.watchBetween(start, end).map(_mapTasks).distinct(listEquals);

  Stream<PlannerTask?> watchById(String id) =>
      dao.watchById(id).map((row) => row == null ? null : taskFromRow(row));

  Stream<List<PlannerTask>> watchUpcoming(DateTime start) =>
      dao.watchFrom(start).map(_mapTasks).distinct(listEquals);

  Stream<List<PlannerTask>> watchForWeeklyGoal(String id) =>
      dao.watchByWeeklyGoal(id).map(_mapTasks).distinct(listEquals);

  Stream<List<PlannerTask>> watchForMonthlyGoal(String id) =>
      dao.watchByMonthlyGoal(id).map(_mapTasks).distinct(listEquals);

  List<PlannerTask> _mapTasks(List<TaskRow> rows) =>
      List.unmodifiable(rows.map(taskFromRow));
  Future<List<PlannerTask>> forWeeklyGoal(String id) async =>
      _mapTasks(await dao.byWeeklyGoal(id));

  Future<void> setCompletion(String id, bool complete, DateTime changed) =>
      dao.setCompletion(id, complete, changed);

  Future<int> deleteByWeeklyGoal(String id) => dao.deleteByWeeklyGoal(id);

  Future<int> unlinkWeeklyGoal(String id, DateTime changed) =>
      dao.unlinkWeeklyGoal(id, changed);
}
