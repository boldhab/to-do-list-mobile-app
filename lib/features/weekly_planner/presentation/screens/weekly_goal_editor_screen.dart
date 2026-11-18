import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../monthly_planner/presentation/providers/monthly_goal_provider.dart';
import '../../../planning/domain/planner_commands.dart';
import '../../../planning/presentation/goal_form.dart';
import '../../../planning/presentation/planner_feedback.dart';
import '../../../planning/presentation/planner_provider.dart';
import '../../../planning/presentation/planner_query_status.dart';
import '../../../tasks/presentation/providers/selected_date_provider.dart';
import '../../../tasks/presentation/providers/task_query_provider.dart';
import '../providers/weekly_goal_provider.dart';

class WeeklyGoalEditorScreen extends ConsumerWidget {
  const WeeklyGoalEditorScreen({
    super.key,
    this.id,
    this.date,
    this.monthlyGoalId,
  });

  final String? id;
  final DateTime? date;
  final String? monthlyGoalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = id == null ? null : ref.watch(weeklyGoalProvider(id!));
    final DateTime initial =
        goal?.weekStart ??
        (date == null ? ref.watch(selectedWeekProvider) : mondayOf(date!));
    final parents = ref.watch(monthlyGoalsProvider);
    final taskQuery = id == null
        ? null
        : ref.watch(tasksForWeeklyGoalProvider(id!));
    final children = taskQuery?.asData?.value ?? const [];
    void close() => returnToPlanner(context, RouteNames.weekly);
    return PlannerPage(
      title: id == null ? 'New Weekly Goal' : 'Edit Weekly Goal',
      children: [
        if (id != null && goal == null) ...[
          const EmptyState('This weekly goal could not be found.'),
          OutlinedButton(
            onPressed: close,
            child: const Text('Back to planner'),
          ),
        ] else if (taskQuery != null && taskQuery.asData == null)
          PlannerQueryStatus(taskQuery)
        else
          GoalForm(
            monthly: false,
            initial: (
              title: goal?.title ?? '',
              description: goal?.description ?? '',
              period: initial,
              parentId: goal?.monthlyGoalId ?? monthlyGoalId,
              completed: goal?.isCompleted ?? false,
            ),
            parents: {
              for (final parent in parents)
                parent.id:
                    '${parent.title} · ${DateFormat.yMMM().format(DateTime(parent.year, parent.month))}',
            },
            onCancel: close,
            onSave: (draft) async {
              final service = ref.read(plannerServiceProvider);
              WeekMovePolicy? move;
              if (children.any(
                (task) => !dateInRange(
                  task.scheduledDate,
                  draft.period,
                  sundayOf(draft.period),
                ),
              )) {
                move = await _chooseMove(context);
                if (!context.mounted || move == null) return;
              }
              final saved = await runPlannerAction(
                context,
                () => service.saveWeekly(
                  id: id,
                  title: draft.title,
                  description: draft.description,
                  weekStart: draft.period,
                  monthlyGoalId: draft.parentId,
                  completed: draft.completed,
                  move: move,
                ),
                'Weekly goal saved.',
              );
              if (!saved || !context.mounted) return;
              if (!context.canPop() ||
                  (date == null && draft.period != initial)) {
                ref.read(selectedDateProvider.notifier).select(draft.period);
              }
              close();
            },
          ),
      ],
    );
  }
}

Future<WeekMovePolicy?> _chooseMove(BuildContext context) =>
    showDialog<WeekMovePolicy>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move this weekly goal?'),
        content: const Text(
          'Some linked tasks fall outside the new week. Keep their dates and unlink them, or move them to the same weekdays in the new week. Deadlines keep their original dates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, WeekMovePolicy.unlink),
            child: const Text('Unlink tasks'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, WeekMovePolicy.reschedule),
            child: const Text('Reschedule tasks'),
          ),
        ],
      ),
    );
