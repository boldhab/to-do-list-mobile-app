import 'package:drift/drift.dart';

import '../../../features/monthly_planner/domain/entities/monthly_goal.dart';
import '../app_database.dart';

MonthlyGoal monthlyGoalFromRow(MonthlyGoalRow row) => MonthlyGoal(
  id: row.id,
  title: row.title,
  description: row.description,
  year: row.year,
  month: row.month,
  isCompleted: row.isCompleted,
  createdAt: row.createdAt.toLocal(),
  updatedAt: row.updatedAt.toLocal(),
);

MonthlyGoalsCompanion monthlyGoalToRow(MonthlyGoal entity) =>
    MonthlyGoalsCompanion(
      id: Value(entity.id),
      title: Value(entity.title),
      description: Value(entity.description),
      year: Value(entity.year),
      month: Value(entity.month),
      isCompleted: Value(entity.isCompleted),
      createdAt: Value(entity.createdAt.toUtc()),
      updatedAt: Value(entity.updatedAt.toUtc()),
    );
