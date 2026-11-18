import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../planning/presentation/planner_feedback.dart';
import '../../../weekly_planner/presentation/providers/weekly_goal_provider.dart';
import '../../domain/entities/task.dart';
import '../../../planning/presentation/planner_provider.dart';
import 'task_priority_badge.dart';
import '../../../productivity/data/productivity_store.dart';
import '../../../productivity/data/preferences.dart';
import '../../../recurrence/domain/recurrence_rule.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.weeklyGoalLabel,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.onReschedule,
    this.dateLabel,
  });

  final PlannerTask task;
  final String? weeklyGoalLabel;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onReschedule;
  final String? dateLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xs,
          AppSpacing.sm,
          AppSpacing.xs,
          AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(),
              semanticLabel:
                  '${task.isCompleted ? 'Reopen' : 'Complete'} ${task.title}',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (task.description != null)
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        PriorityBadge(task.priority),
                        if (parseOccurrence(task.id) != null)
                          const Tooltip(
                            message: 'Recurring task',
                            child: Icon(Icons.repeat, size: 16),
                          ),
                        Text(
                          dateLabel ??
                              DateFormat.yMMMd().format(task.scheduledDate),
                          style: theme.textTheme.bodySmall,
                        ),
                        if (task.dueAt case final deadline?)
                          Text(
                            'Due ${DateFormat.yMMMd().add_jm().format(deadline)}',
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                    if (weeklyGoalLabel != null)
                      Text(
                        'Weekly goal · $weeklyGoalLabel',
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Actions for ${task.title}',
              onSelected: (value) => switch (value) {
                'edit' => onEdit(),
                'reschedule' => onReschedule?.call(),
                _ => onDelete(),
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                if (onReschedule != null)
                  const PopupMenuItem(
                    value: 'reschedule',
                    child: Text('Reschedule'),
                  ),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListItem extends ConsumerWidget {
  const TaskListItem(this.task, {super.key});

  final PlannerTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);
    final goalId = task.weeklyGoalId;
    final weeklyGoalLabel = goalId == null
        ? null
        : ref.watch(weeklyGoalProvider(goalId).select((goal) => goal?.title));
    return TaskCard(
      task: task,
      dateLabel: plannerDate(task.scheduledDate, preferences),
      weeklyGoalLabel: weeklyGoalLabel,
      onReschedule: () => context.push(RouteNames.edit(task.id), extra: true),
      onToggle: () => runPlannerAction(
        context,
        () => parseOccurrence(task.id) == null
            ? ref.read(plannerServiceProvider).toggleTask(task.id)
            : ref.read(productivityStoreProvider).toggle(task.id),
        task.isCompleted ? 'Task reopened.' : 'Task completed.',
      ),
      onEdit: () => context.push(RouteNames.edit(task.id)),
      onDelete: () async {
        if (parseOccurrence(task.id) != null) {
          final scope = await _deleteScope(context);
          if (scope != null && context.mounted) {
            await runPlannerAction(
              context,
              () => ref.read(productivityStoreProvider).delete(task.id, scope),
              'Recurring task updated.',
            );
          }
          return;
        }
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete task?'),
            content: Text('“${task.title}” will be removed from your planner.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirmed == true && context.mounted) {
          runPlannerAction(
            context,
            () => ref.read(plannerServiceProvider).deleteTask(task.id),
            'Task deleted.',
            failure: 'Unable to delete task. Please try again.',
          );
        }
      },
    );
  }
}

Future<SeriesScope?> _deleteScope(BuildContext context) =>
    showDialog<SeriesScope>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete recurring task?'),
        content: const Text(
          'Deleting the entire series removes its completion history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, SeriesScope.occurrence),
            child: const Text('This occurrence'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, SeriesScope.future),
            child: const Text('This and future'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, SeriesScope.series),
            child: const Text('Delete series'),
          ),
        ],
      ),
    );
