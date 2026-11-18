import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/route_names.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/progress_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../analytics/presentation/providers/progress_provider.dart';
import '../../monthly_planner/presentation/providers/monthly_goal_provider.dart';
import '../../tasks/presentation/providers/selected_date_provider.dart';
import '../../tasks/presentation/providers/task_query_provider.dart';
import '../../tasks/presentation/widgets/task_card.dart';
import '../../weekly_planner/presentation/providers/weekly_goal_provider.dart';
import '../domain/planner_commands.dart';
import 'goal_cards.dart';
import 'planner_feedback.dart';
import 'planner_provider.dart';
import 'planner_query_status.dart';

class GoalDetailScreen extends ConsumerWidget {
  const GoalDetailScreen({super.key, required this.id, required this.monthly});

  final String id;
  final bool monthly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = monthly ? ref.watch(monthlyGoalProvider(id)) : null;
    final week = monthly ? null : ref.watch(weeklyGoalProvider(id));
    final title = month?.title ?? week?.title;
    final fallback = monthly ? RouteNames.monthly : RouteNames.weekly;
    final heading = monthly ? 'Monthly Goal' : 'Weekly Goal';
    if (title == null) {
      return PlannerPage(
        title: heading,
        children: [
          const EmptyState('This goal could not be found.'),
          OutlinedButton(
            onPressed: () => returnToPlanner(context, fallback),
            child: const Text('Back to planner'),
          ),
        ],
      );
    }
    final completed = month?.isCompleted ?? week!.isCompleted;
    final description = month?.description ?? week?.description;
    final weeklyChildren = monthly
        ? ref
              .watch(weeklyGoalsProvider)
              .where((goal) => goal.monthlyGoalId == id)
              .toList()
        : null;
    final taskQuery = monthly
        ? null
        : ref.watch(tasksForWeeklyGoalProvider(id));
    final tasks = taskQuery?.asData?.value ?? const [];
    final parentId = week?.monthlyGoalId;
    final parent = parentId == null
        ? null
        : ref.watch(monthlyGoalProvider(parentId));
    final hasChildren = monthly ? weeklyChildren!.isNotEmpty : tasks.isNotEmpty;
    final service = ref.read(plannerServiceProvider);
    final today = DateTime.now();
    final defaultWeek = month != null
        ? (today.year == month.year && today.month == month.month
              ? today
              : DateTime(month.year, month.month))
        : null;
    final date = week == null
        ? null
        : dateForWeek(ref.read(selectedDateProvider), week.weekStart);
    return PlannerPage(
      title: heading,
      children: [
        SectionHeader(title),
        Text(
          month != null
              ? DateFormat.yMMMM().format(DateTime(month.year, month.month))
              : '${DateFormat.yMMMd().format(week!.weekStart)} – ${DateFormat.yMMMd().format(week.weekEnd)}',
        ),
        if (description != null) Text(description),
        Text(completed ? 'Goal complete' : 'Goal open'),
        if (week != null)
          if (parent == null)
            const Text('Independent weekly goal')
          else
            TextButton(
              onPressed: () => context.push(RouteNames.monthlyGoal(parent.id)),
              child: Text('Monthly goal · ${parent.title}'),
            ),
        ProgressCard(
          title: 'Linked task completion',
          progress: monthly
              ? ref.watch(monthlyGoalProgressProvider(id))
              : ref.watch(weeklyGoalProgressProvider(id)),
          featured: true,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: () => monthly
                  ? context.push(
                      RouteNames.newWeeklyGoal,
                      extra: (date: defaultWeek!, monthlyGoalId: id),
                    )
                  : context.push(
                      RouteNames.create,
                      extra: (date: date!, weeklyGoalId: id),
                    ),
              icon: const Icon(Icons.add),
              label: Text(monthly ? 'Add Weekly Goal' : 'Add Daily Task'),
            ),
            OutlinedButton(
              onPressed: () => context.push(
                monthly
                    ? RouteNames.editMonthlyGoal(id)
                    : RouteNames.editWeeklyGoal(id),
              ),
              child: const Text('Edit Goal'),
            ),
            OutlinedButton(
              onPressed: () => runPlannerAction(
                context,
                () => monthly
                    ? service.toggleMonthly(id)
                    : service.toggleWeekly(id),
                completed ? 'Goal reopened.' : 'Goal completed.',
              ),
              child: Text(completed ? 'Reopen Goal' : 'Mark Goal Complete'),
            ),
            TextButton(
              onPressed: taskQuery != null && taskQuery.asData == null
                  ? null
                  : () async {
                      final policy = await _confirmDelete(
                        context,
                        title,
                        hasChildren,
                        monthly,
                      );
                      if (!context.mounted || policy == null) return;
                      // A goal that acquired children while the simple dialog was open
                      // still uses the non-destructive preservation policy.
                      if (await runPlannerAction(
                        context,
                        () => monthly
                            ? service.deleteMonthly(id, policy)
                            : service.deleteWeekly(id, policy),
                        'Goal deleted.',
                        failure: 'Unable to delete goal. Please try again.',
                      )) {
                        if (context.mounted) returnToPlanner(context, fallback);
                      }
                    },
              child: const Text('Delete Goal'),
            ),
          ],
        ),
        SectionHeader(monthly ? 'Weekly goals' : 'Daily tasks'),
        if (taskQuery != null && taskQuery.asData == null)
          PlannerQueryStatus(taskQuery)
        else if (!hasChildren)
          EmptyState(
            monthly
                ? 'No weekly goals are linked yet.'
                : 'No daily tasks are linked yet.',
          )
        else if (weeklyChildren != null)
          for (final child in weeklyChildren) WeeklyGoalCard(child)
        else
          for (final task in tasks) TaskListItem(task, key: ValueKey(task.id)),
      ],
    );
  }
}

Future<DeletePolicy?> _confirmDelete(
  BuildContext context,
  String title,
  bool hasChildren,
  bool monthly,
) => showDialog<DeletePolicy>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Delete goal?'),
    content: Text(
      hasChildren
          ? '“$title” has linked ${monthly ? 'weekly goals' : 'tasks'}. Choose what to keep.'
          : '“$title” will be removed from your planner.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      if (hasChildren)
        OutlinedButton(
          onPressed: () => Navigator.pop(context, DeletePolicy.preserve),
          child: Text(monthly ? 'Keep weekly goals' : 'Keep tasks'),
        ),
      FilledButton(
        onPressed: () => Navigator.pop(
          context,
          hasChildren ? DeletePolicy.cascade : DeletePolicy.preserve,
        ),
        child: Text(
          hasChildren
              ? monthly
                    ? 'Delete goal and descendants'
                    : 'Delete goal and tasks'
              : 'Delete',
        ),
      ),
    ],
  ),
);
