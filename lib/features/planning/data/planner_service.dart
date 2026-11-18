import '../../../core/errors/planner_exception.dart';
import '../../../core/utils/date_helpers.dart';
import '../../monthly_planner/data/repositories/in_memory_monthly_goal_repository.dart';
import '../../monthly_planner/domain/entities/monthly_goal.dart';
import '../../tasks/data/repositories/in_memory_task_repository.dart';
import '../../tasks/domain/entities/task.dart';
import '../../weekly_planner/data/repositories/in_memory_weekly_goal_repository.dart';
import '../../weekly_planner/domain/entities/weekly_goal.dart';
import '../domain/validation.dart';
import '../domain/planner_commands.dart';
import 'in_memory_planner_store.dart';

export '../domain/planner_commands.dart';

class PlannerService implements PlannerCommands {
  PlannerService(this.store)
    : monthly = InMemoryMonthlyGoalRepository(store),
      weekly = InMemoryWeeklyGoalRepository(store),
      tasks = InMemoryTaskRepository(store);

  final InMemoryPlannerStore store;
  final InMemoryMonthlyGoalRepository monthly;
  final InMemoryWeeklyGoalRepository weekly;
  final InMemoryTaskRepository tasks;

  @override
  MonthlyGoal saveMonthly({
    String? id,
    required String title,
    String? description,
    required int year,
    required int month,
    required bool completed,
  }) {
    final now = DateTime.now();
    final old = id == null ? null : monthly.require(id);
    final goal = MonthlyGoal(
      id: old?.id ?? store.nextId('month', (id) => monthly.find(id) != null),
      title: validatedTitle(title),
      description: cleanDescription(description),
      year: year,
      month: month,
      isCompleted: completed,
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
    );
    monthly.save(goal, creating: old == null);
    return goal;
  }

  @override
  WeeklyGoal saveWeekly({
    String? id,
    required String title,
    String? description,
    required DateTime weekStart,
    String? monthlyGoalId,
    required bool completed,
    WeekMovePolicy? move,
  }) {
    final now = DateTime.now();
    final old = id == null ? null : weekly.require(id);
    final goal = WeeklyGoal(
      id: old?.id ?? store.nextId('week', (id) => weekly.find(id) != null),
      title: validatedTitle(title),
      description: cleanDescription(description),
      weekStart: dateOnly(weekStart),
      weekEnd: shiftDay(weekStart, 6),
      monthlyGoalId: monthlyGoalId,
      isCompleted: completed,
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
    );
    final snapshot = store.snapshot;
    if (old == null || !hasIncompatibleTasks(old.id, goal.weekStart)) {
      weekly.save(goal, creating: old == null);
      return goal;
    }
    if (move == null) {
      throw PlannerException(
        'Choose how to handle tasks outside the new week.',
      );
    }
    store.commit(
      snapshot.copyWith(
        weekly: snapshot.weekly.map((item) => item.id == id ? goal : item),
        tasks: snapshot.tasks.map((task) {
          if (task.weeklyGoalId != old.id ||
              dateInRange(task.scheduledDate, goal.weekStart, goal.weekEnd)) {
            return task;
          }
          return switch (move) {
            WeekMovePolicy.unlink => task.copyWith(
              clearWeeklyGoal: true,
              updatedAt: now,
            ),
            WeekMovePolicy.reschedule => task.copyWith(
              scheduledDate: shiftDay(
                goal.weekStart,
                task.scheduledDate.weekday - 1,
              ),
              updatedAt: now,
            ),
          };
        }),
      ),
    );
    return goal;
  }

  bool hasIncompatibleTasks(String id, DateTime start) => tasks.items.any(
    (task) =>
        task.weeklyGoalId == id &&
        !dateInRange(task.scheduledDate, start, shiftDay(start, 6)),
  );

  @override
  PlannerTask saveTask({
    String? id,
    required String title,
    String? description,
    required DateTime date,
    DateTime? dueAt,
    String? weeklyGoalId,
    required TaskPriority priority,
    required bool completed,
  }) {
    final old = id == null ? null : tasks.require(id);
    final now = DateTime.now();
    final task = PlannerTask(
      id: old?.id ?? store.nextId('task', (id) => tasks.find(id) != null),
      title: validatedTitle(title),
      description: cleanDescription(description),
      scheduledDate: dateOnly(date),
      weeklyGoalId: weeklyGoalId,
      dueAt: dueAt,
      priority: priority,
      isCompleted: completed,
      completedAt: completed ? old?.completedAt ?? now : null,
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
    );
    tasks.save(task, creating: old == null);
    return task;
  }

  @override
  void deleteTask(String id) => tasks.remove(id);

  @override
  void toggleTask(String id) {
    final task = tasks.require(id);
    final now = DateTime.now();
    tasks.save(
      task.copyWith(
        isCompleted: !task.isCompleted,
        completedAt: task.isCompleted ? null : now,
        updatedAt: now,
      ),
      creating: false,
    );
  }

  @override
  void toggleMonthly(String id) {
    final goal = monthly.require(id);
    monthly.save(
      goal.copyWith(isCompleted: !goal.isCompleted, updatedAt: DateTime.now()),
      creating: false,
    );
  }

  @override
  void toggleWeekly(String id) {
    final goal = weekly.require(id);
    weekly.save(
      goal.copyWith(isCompleted: !goal.isCompleted, updatedAt: DateTime.now()),
      creating: false,
    );
  }

  @override
  void deleteMonthly(String id, DeletePolicy policy) {
    monthly.require(id);
    final snapshot = store.snapshot;
    final now = DateTime.now();
    final children = snapshot.weekly
        .where((goal) => goal.monthlyGoalId == id)
        .map((goal) => goal.id)
        .toSet();
    store.commit(
      snapshot.copyWith(
        monthly: snapshot.monthly.where((goal) => goal.id != id),
        weekly: switch (policy) {
          DeletePolicy.cascade => snapshot.weekly.where(
            (goal) => !children.contains(goal.id),
          ),
          DeletePolicy.preserve => snapshot.weekly.map(
            (goal) => children.contains(goal.id)
                ? goal.copyWith(clearMonthlyGoalId: true, updatedAt: now)
                : goal,
          ),
        },
        tasks: policy == DeletePolicy.cascade
            ? snapshot.tasks.where(
                (task) => !children.contains(task.weeklyGoalId),
              )
            : null,
      ),
    );
  }

  @override
  void deleteWeekly(String id, DeletePolicy policy) {
    weekly.require(id);
    final snapshot = store.snapshot;
    final now = DateTime.now();
    store.commit(
      snapshot.copyWith(
        weekly: snapshot.weekly.where((goal) => goal.id != id),
        tasks: switch (policy) {
          DeletePolicy.cascade => snapshot.tasks.where(
            (task) => task.weeklyGoalId != id,
          ),
          DeletePolicy.preserve => snapshot.tasks.map(
            (task) => task.weeklyGoalId == id
                ? task.copyWith(clearWeeklyGoal: true, updatedAt: now)
                : task,
          ),
        },
      ),
    );
  }
}
