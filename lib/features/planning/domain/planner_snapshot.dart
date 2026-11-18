import '../../../core/errors/planner_exception.dart';
import '../../../core/utils/date_helpers.dart';
import '../../monthly_planner/domain/entities/monthly_goal.dart';
import '../../tasks/domain/entities/task.dart';
import '../../weekly_planner/domain/entities/weekly_goal.dart';
import 'validation.dart';

class PlannerSnapshot {
  PlannerSnapshot({
    Iterable<MonthlyGoal> monthly = const [],
    Iterable<WeeklyGoal> weekly = const [],
    Iterable<PlannerTask> tasks = const [],
  }) : monthly = List.unmodifiable(monthly),
       weekly = List.unmodifiable(weekly),
       tasks = List.unmodifiable(tasks);

  const PlannerSnapshot._(this.monthly, this.weekly, this.tasks);

  final List<MonthlyGoal> monthly;
  final List<WeeklyGoal> weekly;
  final List<PlannerTask> tasks;

  PlannerSnapshot copyWith({
    Iterable<MonthlyGoal>? monthly,
    Iterable<WeeklyGoal>? weekly,
    Iterable<PlannerTask>? tasks,
  }) => PlannerSnapshot._(
    monthly == null ? this.monthly : List.unmodifiable(monthly),
    weekly == null ? this.weekly : List.unmodifiable(weekly),
    tasks == null ? this.tasks : List.unmodifiable(tasks),
  );

  void validate() {
    _validateIds(monthly.map((goal) => goal.id));
    _validateIds(weekly.map((goal) => goal.id));
    _validateIds(tasks.map((task) => task.id));
    final monthIds = monthly.map((goal) => goal.id).toSet();
    final weeklyById = {for (final goal in weekly) goal.id: goal};
    for (final goal in monthly) {
      validatedTitle(goal.title);
      validateYear(goal.year);
      if (goal.month < 1 || goal.month > 12) {
        throw PlannerException('Choose a month from January to December.');
      }
    }
    for (final goal in weekly) {
      validatedTitle(goal.title);
      validateYear(goal.weekStart.year);
      validateYear(goal.weekEnd.year);
      if (goal.weekStart != mondayOf(goal.weekStart) ||
          goal.weekEnd != sundayOf(goal.weekStart)) {
        throw PlannerException('Choose a Monday–Sunday week.');
      }
      if (goal.monthlyGoalId != null &&
          !monthIds.contains(goal.monthlyGoalId)) {
        throw PlannerException('The selected monthly goal no longer exists.');
      }
    }
    for (final task in tasks) {
      validatedTitle(task.title);
      validateYear(task.scheduledDate.year);
      if (task.dueAt case final deadline?) validateYear(deadline.year);
      if (task.isCompleted != (task.completedAt != null)) {
        throw PlannerException(
          'Task completion requires a consistent timestamp.',
        );
      }
      if (task.weeklyGoalId != null) {
        final goal = weeklyById[task.weeklyGoalId];
        if (goal == null) {
          throw PlannerException('The selected weekly goal no longer exists.');
        }
        if (!dateInRange(task.scheduledDate, goal.weekStart, goal.weekEnd)) {
          throw PlannerException(
            'Schedule the task within the selected goal’s week or unlink it.',
          );
        }
      }
    }
  }

  void _validateIds(Iterable<String> ids) {
    final seen = <String>{};
    for (final id in ids) {
      if (id.trim().isEmpty || !seen.add(id)) {
        throw PlannerException('Each item must have a unique identifier.');
      }
    }
  }
}
