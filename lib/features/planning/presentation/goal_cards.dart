import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/progress_calculator.dart';
import '../../analytics/presentation/providers/progress_provider.dart';
import '../../monthly_planner/domain/entities/monthly_goal.dart';
import '../../monthly_planner/presentation/providers/monthly_goal_provider.dart';
import '../../tasks/presentation/providers/selected_date_provider.dart';
import '../../weekly_planner/domain/entities/weekly_goal.dart';
import '../../weekly_planner/presentation/providers/weekly_goal_provider.dart';

class MonthlyGoalCard extends ConsumerWidget {
  const MonthlyGoalCard(this.goal, {super.key});
  final MonthlyGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(
      weeklyGoalsProvider.select(
        (goals) => goals.where((week) => week.monthlyGoalId == goal.id).length,
      ),
    );
    return _GoalCard(
      icon: Icons.flag_outlined,
      title: goal.title,
      subtitle:
          '$count weekly goals · ${DateFormat.yMMM().format(DateTime(goal.year, goal.month))}',
      completed: goal.isCompleted,
      progress: ref.watch(monthlyGoalProgressProvider(goal.id)),
      onOpen: () => context.push(RouteNames.monthlyGoal(goal.id)),
    );
  }
}

class WeeklyGoalCard extends ConsumerWidget {
  const WeeklyGoalCard(this.goal, {super.key});
  final WeeklyGoal goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentId = goal.monthlyGoalId;
    final parent = parentId == null
        ? null
        : ref.watch(monthlyGoalProvider(parentId));
    return _GoalCard(
      icon: Icons.view_week_outlined,
      title: goal.title,
      subtitle: parent == null
          ? 'Independent weekly goal'
          : 'Monthly goal · ${parent.title}',
      completed: goal.isCompleted,
      progress: ref.watch(weeklyGoalProgressProvider(goal.id)),
      onOpen: () => context.push(RouteNames.weeklyGoal(goal.id)),
      onAdd: () => context.push(
        RouteNames.create,
        extra: (
          date: dateForWeek(ref.read(selectedDateProvider), goal.weekStart),
          weeklyGoalId: goal.id,
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.progress,
    required this.onOpen,
    this.onAdd,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool completed;
  final TaskProgress progress;
  final VoidCallback onOpen;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        spacing: AppSpacing.sm,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon),
            trailing: const Icon(Icons.chevron_right),
            title: Text(title),
            subtitle: Text(subtitle),
            onTap: onOpen,
          ),
          Text(completed ? 'Goal complete' : 'Goal open'),
          LinearProgressIndicator(
            value: progress.ratio,
            semanticsLabel: 'Linked task progress',
          ),
          Text(
            '${progress.completed} of ${progress.total} linked tasks complete (${progress.percentage}%)',
          ),
          if (onAdd != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Add Daily Task'),
              ),
            ),
        ],
      ),
    ),
  );
}
