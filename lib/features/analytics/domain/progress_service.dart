import '../../../core/utils/progress_calculator.dart';
import '../../planning/domain/planner_snapshot.dart';
import '../../tasks/domain/entities/task.dart';

List<PlannerTask> tasksForWeeklyGoals(
  PlannerSnapshot snapshot,
  Set<String> ids,
) {
  final seen = <String>{};
  return snapshot.tasks
      .where((task) => ids.contains(task.weeklyGoalId) && seen.add(task.id))
      .toList();
}

TaskProgress weeklyGoalProgress(PlannerSnapshot snapshot, String id) =>
    TaskProgress(tasksForWeeklyGoals(snapshot, {id}));

TaskProgress monthlyGoalProgress(PlannerSnapshot snapshot, String id) =>
    TaskProgress(
      tasksForWeeklyGoals(
        snapshot,
        snapshot.weekly
            .where((goal) => goal.monthlyGoalId == id)
            .map((goal) => goal.id)
            .toSet(),
      ),
    );
