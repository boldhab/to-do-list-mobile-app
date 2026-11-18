import 'dart:async';

import '../../monthly_planner/domain/entities/monthly_goal.dart';
import '../../weekly_planner/domain/entities/weekly_goal.dart';
import '../../tasks/domain/entities/task.dart';

enum DeletePolicy { preserve, cascade }

enum WeekMovePolicy { unlink, reschedule }

abstract interface class PlannerCommands {
  FutureOr<MonthlyGoal> saveMonthly({
    String? id,
    required String title,
    String? description,
    required int year,
    required int month,
    required bool completed,
  });

  FutureOr<WeeklyGoal> saveWeekly({
    String? id,
    required String title,
    String? description,
    required DateTime weekStart,
    String? monthlyGoalId,
    required bool completed,
    WeekMovePolicy? move,
  });

  FutureOr<PlannerTask> saveTask({
    String? id,
    required String title,
    String? description,
    required DateTime date,
    DateTime? dueAt,
    String? weeklyGoalId,
    required TaskPriority priority,
    required bool completed,
  });

  FutureOr<void> deleteTask(String id);

  FutureOr<void> toggleTask(String id);

  FutureOr<void> toggleMonthly(String id);

  FutureOr<void> toggleWeekly(String id);

  FutureOr<void> deleteMonthly(String id, DeletePolicy policy);

  FutureOr<void> deleteWeekly(String id, DeletePolicy policy);
}
