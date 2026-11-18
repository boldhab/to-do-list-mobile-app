import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/period_header.dart';
import '../../../../core/widgets/progress_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../analytics/presentation/providers/progress_provider.dart';
import '../../../tasks/presentation/providers/selected_date_provider.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../../../tasks/presentation/providers/task_query_provider.dart';
import '../../../planning/presentation/planner_query_status.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../../../weekly_planner/presentation/providers/weekly_goal_provider.dart';

class DailyScreen extends ConsumerWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedDateProvider);
    final selection = ref.read(selectedDateProvider.notifier);
    final taskQuery = ref.watch(
      tasksInPeriodProvider((start: date, end: date)),
    );
    final tasks = taskQuery.asData?.value ?? const [];
    final filter = ref.watch(taskFilterProvider);
    final goals = ref
        .watch(weeklyGoalsProvider)
        .where((goal) => dateInRange(date, goal.weekStart, goal.weekEnd))
        .toList();
    final requestedGoal = ref.watch(taskGoalFilterProvider);
    final goalId = goals.any((goal) => goal.id == requestedGoal)
        ? requestedGoal
        : null;
    final order = ref.watch(taskSortProvider);
    final visible = sortTasks(
      filterTasks(
        tasks,
        filter,
      ).where((task) => goalId == null || task.weeklyGoalId == goalId),
      order,
    );
    void add() => context.push(RouteNames.create);

    return PlannerPage(
      title: 'Daily Planner',
      taskItemCount: visible.length,
      taskItemBuilder: (context, index) =>
          TaskListItem(visible[index], key: ValueKey(visible[index].id)),
      children: [
        PeriodHeader(
          title: DateFormat.EEEE().format(date),
          subtitle: DateFormat.yMMMMd().format(date),
          unit: 'day',
          onPrevious: () => selection.select(shiftDay(date, -1)),
          onNext: () => selection.select(shiftDay(date, 1)),
        ),
        Align(
          alignment: Alignment.center,
          child: OutlinedButton(
            onPressed: sameDay(date, DateTime.now())
                ? null
                : () => selection.select(DateTime.now()),
            child: const Text('Jump to today'),
          ),
        ),
        ProgressCard(
          title: 'Daily task progress',
          progress: ref.watch(periodProgressProvider((start: date, end: date))),
          featured: true,
        ),
        const SectionHeader('Tasks'),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final (value, label) in [
              (TaskFilter.all, 'All'),
              (TaskFilter.pending, 'Pending'),
              (TaskFilter.completed, 'Completed'),
              (TaskFilter.highPriority, 'High priority'),
            ])
              ChoiceChip(
                label: Text(label),
                selected: value == filter,
                onSelected: (_) =>
                    ref.read(taskFilterProvider.notifier).select(value),
              ),
            FilledButton.icon(
              onPressed: add,
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            ),
          ],
        ),
        if (goals.isNotEmpty)
          DropdownButtonFormField<String>(
            key: ValueKey(goalId),
            initialValue: goalId ?? '',
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Filter by weekly goal',
            ),
            items: [
              const DropdownMenuItem(
                value: '',
                child: Text('All weekly goals'),
              ),
              for (final goal in goals)
                DropdownMenuItem(
                  value: goal.id,
                  child: Text(goal.title, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (id) => ref
                .read(taskGoalFilterProvider.notifier)
                .select(id == '' ? null : id),
          ),
        if (tasks.isNotEmpty)
          DropdownButtonFormField<TaskSort>(
            initialValue: order,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Sort tasks by'),
            items: const [
              DropdownMenuItem(
                value: TaskSort.scheduled,
                child: Text('Scheduled date'),
              ),
              DropdownMenuItem(
                value: TaskSort.deadline,
                child: Text('Deadline'),
              ),
              DropdownMenuItem(
                value: TaskSort.priority,
                child: Text('Priority'),
              ),
              DropdownMenuItem(
                value: TaskSort.completion,
                child: Text('Completion status'),
              ),
            ],
            onChanged: (sort) {
              if (sort != null) {
                ref.read(taskSortProvider.notifier).select(sort);
              }
            },
          ),
        if (taskQuery.asData == null)
          PlannerQueryStatus(taskQuery)
        else if (tasks.isEmpty)
          EmptyState(
            'You have a clear day. Add a task to get started.',
            onAdd: add,
          )
        else if (visible.isEmpty)
          EmptyState('No tasks match this filter.'),
      ],
    );
  }
}
