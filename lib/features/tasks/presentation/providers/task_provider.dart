import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../planning/domain/planner_commands.dart';
import '../../../planning/presentation/planner_provider.dart';
import '../../domain/entities/task.dart';

export '../../../../core/utils/progress_calculator.dart';

enum TaskFilter { all, pending, completed, highPriority }

enum TaskSort { scheduled, deadline, priority, completion }

final taskProvider = NotifierProvider<TaskController, List<PlannerTask>>(
  TaskController.new,
);
final taskFilterProvider = NotifierProvider<TaskFilterController, TaskFilter>(
  TaskFilterController.new,
);

class TaskFilterController extends Notifier<TaskFilter> {
  @override
  TaskFilter build() => TaskFilter.all;

  void select(TaskFilter filter) => state = filter;
}

class TaskController extends Notifier<List<PlannerTask>> {
  late PlannerCommands _service;

  @override
  List<PlannerTask> build() {
    _service = ref.watch(plannerServiceProvider);
    return ref.watch(plannerProvider.select((state) => state.tasks));
  }

  FutureOr<PlannerTask> save({
    String? id,
    required String title,
    required String description,
    required DateTime date,
    DateTime? dueAt,
    String? weeklyGoalId,
    required TaskPriority priority,
    required bool completed,
  }) => _service.saveTask(
    id: id,
    title: title,
    description: description,
    date: date,
    dueAt: dueAt,
    weeklyGoalId: weeklyGoalId,
    priority: priority,
    completed: completed,
  );

  FutureOr<void> toggle(String id) => _service.toggleTask(id);

  FutureOr<void> delete(String id) => _service.deleteTask(id);
}

List<PlannerTask> filterTasks(List<PlannerTask> tasks, TaskFilter filter) =>
    switch (filter) {
      TaskFilter.all => tasks,
      TaskFilter.pending => tasks.where((task) => !task.isCompleted).toList(),
      TaskFilter.completed => tasks.where((task) => task.isCompleted).toList(),
      TaskFilter.highPriority =>
        tasks.where((task) => task.priority == TaskPriority.high).toList(),
    };

final taskSortProvider = NotifierProvider<TaskSortController, TaskSort>(
  TaskSortController.new,
);
final taskGoalFilterProvider =
    NotifierProvider<TaskGoalFilterController, String?>(
      TaskGoalFilterController.new,
    );

class TaskSortController extends Notifier<TaskSort> {
  @override
  TaskSort build() => TaskSort.scheduled;
  void select(TaskSort sort) => state = sort;
}

class TaskGoalFilterController extends Notifier<String?> {
  @override
  String? build() => null;
  void select(String? goalId) => state = goalId;
}

List<PlannerTask> sortTasks(Iterable<PlannerTask> tasks, TaskSort order) =>
    tasks.toList()..sort((a, b) {
      final comparison = switch (order) {
        TaskSort.scheduled => a.scheduledDate.compareTo(b.scheduledDate),
        TaskSort.deadline => _compareDeadlines(a.dueAt, b.dueAt),
        TaskSort.priority => b.priority.index.compareTo(a.priority.index),
        TaskSort.completion => (a.isCompleted ? 1 : 0).compareTo(
          b.isCompleted ? 1 : 0,
        ),
      };
      if (comparison != 0) return comparison;
      final date = a.scheduledDate.compareTo(b.scheduledDate);
      if (date != 0) return date;
      final deadline = _compareDeadlines(a.dueAt, b.dueAt);
      return deadline == 0 ? a.id.compareTo(b.id) : deadline;
    });

int _compareDeadlines(DateTime? a, DateTime? b) {
  if (a == null) return b == null ? 0 : 1;
  if (b == null) return -1;
  return a.compareTo(b);
}
