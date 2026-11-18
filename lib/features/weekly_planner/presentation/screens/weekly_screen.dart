import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/period_header.dart';
import '../../../../core/widgets/progress_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../analytics/presentation/providers/progress_provider.dart';
import '../../../tasks/presentation/providers/selected_date_provider.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_query_provider.dart';
import '../../../planning/presentation/planner_query_status.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../../../planning/presentation/goal_cards.dart';
import '../../../../core/widgets/empty_state.dart';
import '../providers/weekly_goal_provider.dart';

class WeeklyScreen extends ConsumerWidget {
  const WeeklyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProvider);
    final selection = ref.read(selectedDateProvider.notifier);
    final first = ref.watch(selectedWeekProvider);
    final goals = ref
        .watch(weeklyGoalsProvider)
        .where((goal) => goal.weekStart == first)
        .toList();
    final last = sundayOf(selected);
    final dates = List.generate(7, (index) => shiftDay(first, index));
    final taskQuery = ref.watch(
      tasksInPeriodProvider((start: first, end: last)),
    );
    final tasks = taskQuery.asData?.value ?? const [];
    final tasksByDay = <DateTime, List<PlannerTask>>{};
    for (final task in tasks) {
      (tasksByDay[dateOnly(task.scheduledDate)] ??= []).add(task);
    }
    return PlannerPage(
      title: 'Weekly Planner',
      children: [
        PeriodHeader(
          title:
              '${DateFormat.yMMMd().format(first)} – ${DateFormat.yMMMd().format(last)}',
          unit: 'week',
          onPrevious: () => selection.select(shiftDay(selected, -7)),
          onNext: () => selection.select(shiftDay(selected, 7)),
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton(
              onPressed: () => selection.select(DateTime.now()),
              child: const Text('Current week'),
            ),
            OutlinedButton(
              onPressed: () => context.go(RouteNames.daily),
              child: const Text('Open day'),
            ),
          ],
        ),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final date in dates)
              ChoiceChip(
                label: Text(DateFormat('EEE d').format(date)),
                selected: sameDay(date, selected),
                onSelected: (_) => selection.select(date),
              ),
          ],
        ),
        ProgressCard(
          title: 'Weekly task progress',
          progress: ref.watch(
            periodProgressProvider((start: first, end: last)),
          ),
          featured: true,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: () => context.push(RouteNames.create),
            icon: const Icon(Icons.add),
            label: const Text('Add Task'),
          ),
        ),
        const SectionHeader('Weekly objectives'),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: () => context.push(RouteNames.newWeeklyGoal),
            icon: const Icon(Icons.add),
            label: const Text('Add Weekly Goal'),
          ),
        ),
        if (goals.isEmpty) const EmptyState('No objectives for this week yet.'),
        for (final goal in goals) WeeklyGoalCard(goal),
        const SectionHeader('Tasks by day'),
        if (taskQuery.asData == null) PlannerQueryStatus(taskQuery),
        if (taskQuery.asData != null)
          for (final date in dates) ...[
            SectionHeader(DateFormat.MMMMEEEEd().format(date)),
            if (tasksByDay[date] case final scheduled?)
              for (final task in scheduled)
                TaskListItem(task, key: ValueKey(task.id))
            else
              const Text('No tasks scheduled'),
          ],
      ],
    );
  }
}
