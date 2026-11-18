import 'package:drift/drift.dart';

import '../../../features/tasks/domain/entities/task.dart';
import '../app_database.dart';
import '../date_storage.dart';

PlannerTask taskFromRow(TaskRow row) => PlannerTask(
  id: row.id,
  title: row.title,
  description: row.description,
  weeklyGoalId: row.weeklyGoalId,
  scheduledDate: decodeDay(row.scheduledDate),
  dueAt: row.dueAt?.toLocal(),
  priority: TaskPriority.values.byName(row.priority),
  isCompleted: row.isCompleted,
  completedAt: row.completedAt?.toLocal(),
  createdAt: row.createdAt.toLocal(),
  updatedAt: row.updatedAt.toLocal(),
);

TasksCompanion taskToRow(PlannerTask entity) => TasksCompanion(
  id: Value(entity.id),
  title: Value(entity.title),
  description: Value(entity.description),
  weeklyGoalId: Value(entity.weeklyGoalId),
  scheduledDate: Value(encodeDay(entity.scheduledDate)),
  dueAt: Value(entity.dueAt?.toUtc()),
  priority: Value(entity.priority.name),
  isCompleted: Value(entity.isCompleted),
  completedAt: Value(entity.completedAt?.toUtc()),
  createdAt: Value(entity.createdAt.toUtc()),
  updatedAt: Value(entity.updatedAt.toUtc()),
);
