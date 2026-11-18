import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tasks_table.dart';
import '../date_storage.dart';
import '../../utils/date_helpers.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.attachedDatabase);

  SimpleSelectStatement<$TasksTable, TaskRow> _ordered() =>
      select(tasks)..orderBy([(row) => OrderingTerm.asc(row.id)]);

  Future<List<TaskRow>> all() => _ordered().get();
  Stream<List<TaskRow>> watchAll() => _ordered().watch();
  Future<TaskRow?> byId(String id) =>
      (select(tasks)..where((row) => row.id.equals(id))).getSingleOrNull();
  Future<int> insertRow(TasksCompanion row) => into(tasks).insert(row);
  Future<int> updateRow(String id, TasksCompanion row) =>
      (update(tasks)..where((existing) => existing.id.equals(id))).write(row);
  Future<int> deleteRow(String id) =>
      (delete(tasks)..where((row) => row.id.equals(id))).go();

  SimpleSelectStatement<$TasksTable, TaskRow> _between(
    DateTime start,
    DateTime end,
  ) => select(tasks)
    ..where(
      (row) =>
          row.scheduledDate.isBiggerOrEqualValue(encodeDay(start)) &
          row.scheduledDate.isSmallerThanValue(encodeDay(end) + 1),
    );

  Future<List<TaskRow>> between(DateTime start, DateTime end) =>
      _between(start, end).get();
  Stream<List<TaskRow>> watchBetween(DateTime start, DateTime end) =>
      _between(start, end).watch();

  Stream<TaskRow?> watchById(String id) =>
      (select(tasks)..where((row) => row.id.equals(id))).watchSingleOrNull();

  Stream<List<TaskRow>> watchFrom(DateTime start) =>
      (select(tasks)..where(
            (row) =>
                row.scheduledDate.isBiggerOrEqualValue(encodeDay(start)) &
                row.isCompleted.equals(false),
          ))
          .watch();

  Stream<List<TaskRow>> watchByWeeklyGoal(String id) =>
      (select(tasks)..where((row) => row.weeklyGoalId.equals(id))).watch();

  Stream<List<TaskRow>> watchByMonthlyGoal(String id) {
    final childIds = selectOnly(weeklyGoals)
      ..addColumns([weeklyGoals.id])
      ..where(weeklyGoals.monthlyGoalId.equals(id));
    return (select(
      tasks,
    )..where((row) => row.weeklyGoalId.isInQuery(childIds))).watch();
  }

  Future<List<TaskRow>> onDay(DateTime date) => between(date, date);

  Future<List<TaskRow>> inWeek(DateTime date) =>
      between(mondayOf(date), sundayOf(date));

  Future<List<TaskRow>> inMonth(int year, int month) =>
      between(DateTime(year, month), DateTime(year, month + 1, 0));

  Future<List<TaskRow>> byWeeklyGoal(String id) =>
      (select(tasks)..where((row) => row.weeklyGoalId.equals(id))).get();

  Future<List<TaskRow>> byCompletion(bool completed) =>
      (select(tasks)..where((row) => row.isCompleted.equals(completed))).get();

  Future<void> setCompletion(String id, bool complete, DateTime changed) async {
    await (update(tasks)..where((row) => row.id.equals(id))).write(
      TasksCompanion(
        isCompleted: Value(complete),
        completedAt: Value(complete ? changed : null),
        updatedAt: Value(changed),
      ),
    );
  }

  Future<int> deleteByWeeklyGoal(String id) =>
      (delete(tasks)..where((row) => row.weeklyGoalId.equals(id))).go();

  Future<int> unlinkWeeklyGoal(String id, DateTime changed) =>
      (update(tasks)..where((row) => row.weeklyGoalId.equals(id))).write(
        TasksCompanion(
          weeklyGoalId: const Value(null),
          updatedAt: Value(changed),
        ),
      );

  Future<void> reschedule(
    String id,
    DateTime date,
    String? parent,
    DateTime changed,
  ) async {
    await (update(tasks)..where((row) => row.id.equals(id))).write(
      TasksCompanion(
        scheduledDate: Value(encodeDay(date)),
        weeklyGoalId: Value(parent),
        updatedAt: Value(changed),
      ),
    );
  }
}
