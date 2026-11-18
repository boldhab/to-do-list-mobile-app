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
import '../../../planning/presentation/goal_cards.dart';
import '../providers/monthly_goal_provider.dart';
import '../widgets/month_calendar.dart';
import '../../../productivity/data/preferences.dart';

class MonthlyScreen extends ConsumerStatefulWidget {
  const MonthlyScreen({super.key});

  @override
  ConsumerState<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends ConsumerState<MonthlyScreen> {
  bool? _weekView;

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedDateProvider);
    final selection = ref.read(selectedDateProvider.notifier);
    final month = ref.watch(selectedMonthProvider);
    final goals = ref
        .watch(monthlyGoalsProvider)
        .where((goal) => goal.year == month.year && goal.month == month.month)
        .toList();
    final preferences = ref.watch(preferencesProvider);
    final weekView = _weekView ?? preferences.calendarWeek;
    final first = displayWeekOf(selected, preferences.sundayFirst);
    final range = weekView
        ? (start: first, end: shiftDay(first, 6))
        : (start: month, end: shiftDay(shiftMonth(month, 1), -1));
    final taskQuery = ref.watch(tasksInPeriodProvider(range));
    final monthTasks = taskQuery.asData?.value ?? const [];
    final dayTasks = tasksBetween(monthTasks, selected, selected);
    void add() => context.push(RouteNames.create);

    return PlannerPage(
      title: 'Monthly Planner',
      children: [
        PeriodHeader(
          title: weekView
              ? '${DateFormat.MMMd().format(first)} – ${DateFormat.yMMMd().format(range.end)}'
              : DateFormat.yMMMM().format(month),
          unit: weekView ? 'week' : 'month',
          onPrevious: () => selection.select(
            weekView ? shiftDay(selected, -7) : shiftMonth(month, -1),
          ),
          onNext: () => selection.select(
            weekView ? shiftDay(selected, 7) : shiftMonth(month, 1),
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Month view'),
              selected: !weekView,
              onSelected: (_) => setState(() => _weekView = false),
            ),
            ChoiceChip(
              label: const Text('Week view'),
              selected: weekView,
              onSelected: (_) => setState(() => _weekView = true),
            ),
            TextButton(
              onPressed: () => selection.select(DateTime.now()),
              child: const Text('Jump to today'),
            ),
          ],
        ),
        MonthCalendar(
          month: month,
          selected: selected,
          today: DateTime.now(),
          tasks: monthTasks,
          weekView: weekView,
          sundayFirst: preferences.sundayFirst,
          onSelect: selection.select,
        ),
        const Text('Numbers show scheduled tasks. ✓ Completed · ! Overdue'),
        SectionHeader(DateFormat.MMMMEEEEd().format(selected)),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FilledButton.icon(
              onPressed: add,
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            ),
            OutlinedButton(
              onPressed: () => context.go(RouteNames.daily),
              child: const Text('Open day'),
            ),
          ],
        ),
        if (taskQuery.asData == null)
          PlannerQueryStatus(taskQuery)
        else if (dayTasks.isEmpty)
          const EmptyState('Nothing scheduled for this date.')
        else
          for (final task in dayTasks)
            TaskListItem(task, key: ValueKey(task.id)),
        ProgressCard(
          title: 'Monthly task progress',
          progress: ref.watch(
            periodProgressProvider((
              start: month,
              end: shiftDay(shiftMonth(month, 1), -1),
            )),
          ),
          featured: true,
        ),
        const SectionHeader('Monthly goals'),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: () => context.push(RouteNames.newMonthlyGoal),
            icon: const Icon(Icons.add),
            label: const Text('Add Monthly Goal'),
          ),
        ),
        if (goals.isEmpty) const EmptyState('No goals for this month yet.'),
        for (final goal in goals) MonthlyGoalCard(goal),
      ],
    );
  }
}
