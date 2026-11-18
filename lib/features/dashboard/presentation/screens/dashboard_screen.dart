import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/progress_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../analytics/presentation/providers/progress_provider.dart';
import '../../../monthly_planner/presentation/providers/monthly_goal_provider.dart';
import '../../../planning/presentation/goal_cards.dart';
import '../../../weekly_planner/presentation/providers/weekly_goal_provider.dart';
import '../../../tasks/presentation/providers/selected_date_provider.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../../../tasks/presentation/providers/task_query_provider.dart';
import '../../../reminders/presentation/upcoming_reminders.dart';
import '../../../analytics/domain/productivity_metrics.dart';
import '../../../planning/presentation/planner_query_status.dart';
import '../../../tasks/presentation/widgets/task_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = dateOnly(now);
    final theme = Theme.of(context);

    final first = mondayOf(today);
    final month = shiftMonth(today, 0);
    final monthlyGoals = ref
        .watch(monthlyGoalsProvider)
        .where((goal) => goal.year == today.year && goal.month == today.month)
        .toList();
    final completedGoals = monthlyGoals
        .where((goal) => goal.isCompleted)
        .length;
    final activeWeeks = ref
        .watch(weeklyGoalsProvider)
        .where((goal) => goal.weekStart == first && !goal.isCompleted)
        .toList();
    final monthQuery = ref.watch(
      tasksInPeriodProvider((
        start: month,
        end: shiftDay(shiftMonth(month, 1), -1),
      )),
    );
    final monthlyOverdue = monthQuery.asData == null
        ? null
        : overdueCount(monthQuery.asData!.value, now);
    final upcomingQuery = ref.watch(upcomingTasksProvider(today));
    final upcoming = sortTasks(
      upcomingQuery.asData?.value ?? const [],
      TaskSort.scheduled,
    );
    final greeting = now.hour < 12
        ? 'Good Morning'
        : now.hour < 18
        ? 'Good Afternoon'
        : 'Good Evening';
    void add() => context.push(RouteNames.create, extra: today);

    return PlannerPage(
      title: 'Task Planner',
      taskItemCount: upcoming.length,
      taskItemBuilder: (context, index) =>
          TaskListItem(upcoming[index], key: ValueKey(upcoming[index].id)),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMEEEEd().format(today),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(greeting, style: theme.textTheme.headlineMedium),
          ],
        ),
        ProgressCard(
          title: 'Today’s overview',
          progress: ref.watch(
            periodProgressProvider((start: today, end: today)),
          ),
          featured: true,
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FilledButton.icon(
              onPressed: add,
              icon: const Icon(Icons.add),
              label: const Text('Add Daily Task'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.push(RouteNames.search),
              icon: const Icon(Icons.search),
              label: const Text('Search tasks'),
            ),
            OutlinedButton.icon(
              onPressed: () => context.push(RouteNames.analytics),
              icon: const Icon(Icons.bar_chart),
              label: const Text('Analytics'),
            ),
            OutlinedButton(
              onPressed: () =>
                  context.push(RouteNames.newWeeklyGoal, extra: today),
              child: const Text('Add Weekly Goal'),
            ),
            OutlinedButton(
              onPressed: () =>
                  context.push(RouteNames.newMonthlyGoal, extra: today),
              child: const Text('Add Monthly Goal'),
            ),
            OutlinedButton(
              onPressed: () {
                ref.read(selectedDateProvider.notifier).select(today);
                context.go(RouteNames.daily);
              },
              child: const Text('View Today’s Tasks'),
            ),
            OutlinedButton(
              onPressed: () => context.go(RouteNames.weekly),
              child: const Text('Open Weekly Planner'),
            ),
            OutlinedButton(
              onPressed: () => context.go(RouteNames.monthly),
              child: const Text('Open Monthly Planner'),
            ),
          ],
        ),
        ProgressCard(
          title: 'This week',
          progress: ref.watch(
            periodProgressProvider((start: first, end: sundayOf(today))),
          ),
        ),
        SectionHeader('Active weekly objectives (${activeWeeks.length})'),
        if (activeWeeks.isEmpty)
          const EmptyState('No active objectives this week.'),
        for (final goal in activeWeeks) WeeklyGoalCard(goal),
        ProgressCard(
          title: 'This month',
          progress: ref.watch(
            periodProgressProvider((
              start: month,
              end: shiftDay(shiftMonth(month, 1), -1),
            )),
          ),
        ),
        const SectionHeader('Monthly goals'),
        Text(
          '$completedGoals completed · ${monthlyGoals.length - completedGoals} remaining',
        ),
        if (monthlyGoals.isEmpty)
          const EmptyState('No goals for this month yet.'),
        for (final goal in monthlyGoals) MonthlyGoalCard(goal),
        if (monthlyOverdue != null)
          OutlinedButton.icon(
            onPressed: () =>
                context.push('${RouteNames.search}?status=overdue'),
            icon: const Icon(Icons.error_outline),
            label: Text(
              '$monthlyOverdue overdue this month · View overdue tasks',
            ),
          ),
        const UpcomingReminders(),
        const SectionHeader('Upcoming tasks'),
        if (upcomingQuery.asData == null)
          PlannerQueryStatus(upcomingQuery)
        else if (upcoming.isEmpty)
          EmptyState('You’re all caught up.', onAdd: add),
      ],
    );
  }
}
