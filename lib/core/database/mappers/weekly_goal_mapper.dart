import 'package:drift/drift.dart';

import '../../../features/weekly_planner/domain/entities/weekly_goal.dart';
import '../app_database.dart';
import '../date_storage.dart';

WeeklyGoal weeklyGoalFromRow(WeeklyGoalRow row) => WeeklyGoal(
  id: row.id,
  title: row.title,
  description: row.description,
  monthlyGoalId: row.monthlyGoalId,
  weekStart: decodeDay(row.weekStart),
  weekEnd: decodeDay(row.weekEnd),
  isCompleted: row.isCompleted,
  createdAt: row.createdAt.toLocal(),
  updatedAt: row.updatedAt.toLocal(),
);

WeeklyGoalsCompanion weeklyGoalToRow(WeeklyGoal entity) => WeeklyGoalsCompanion(
  id: Value(entity.id),
  title: Value(entity.title),
  description: Value(entity.description),
  monthlyGoalId: Value(entity.monthlyGoalId),
  weekStart: Value(encodeDay(entity.weekStart)),
  weekEnd: Value(encodeDay(entity.weekEnd)),
  isCompleted: Value(entity.isCompleted),
  createdAt: Value(entity.createdAt.toUtc()),
  updatedAt: Value(entity.updatedAt.toUtc()),
);
