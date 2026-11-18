import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../planning/presentation/goal_form.dart';
import '../../../planning/presentation/planner_feedback.dart';
import '../../../planning/presentation/planner_provider.dart';
import '../../../tasks/presentation/providers/selected_date_provider.dart';
import '../providers/monthly_goal_provider.dart';

class MonthlyGoalEditorScreen extends ConsumerWidget {
  const MonthlyGoalEditorScreen({super.key, this.id, this.date});

  final String? id;
  final DateTime? date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = id == null ? null : ref.watch(monthlyGoalProvider(id!));
    final DateTime initial = goal == null
        ? date ?? ref.watch(selectedMonthProvider)
        : DateTime(goal.year, goal.month);
    void close() => returnToPlanner(context, RouteNames.monthly);
    return PlannerPage(
      title: id == null ? 'New Monthly Goal' : 'Edit Monthly Goal',
      children: [
        if (id != null && goal == null) ...[
          const EmptyState('This monthly goal could not be found.'),
          OutlinedButton(
            onPressed: close,
            child: const Text('Back to planner'),
          ),
        ] else
          GoalForm(
            monthly: true,
            initial: (
              title: goal?.title ?? '',
              description: goal?.description ?? '',
              period: initial,
              parentId: null,
              completed: goal?.isCompleted ?? false,
            ),
            onCancel: close,
            onSave: (draft) async {
              final saved = await runPlannerAction(
                context,
                () => ref
                    .read(plannerServiceProvider)
                    .saveMonthly(
                      id: id,
                      title: draft.title,
                      description: draft.description,
                      year: draft.period.year,
                      month: draft.period.month,
                      completed: draft.completed,
                    ),
                'Monthly goal saved.',
              );
              if (!saved || !context.mounted) return;
              if (!context.canPop() ||
                  (date == null &&
                      !(draft.period.year == initial.year &&
                          draft.period.month == initial.month))) {
                ref.read(selectedDateProvider.notifier).select(draft.period);
              }
              close();
            },
          ),
      ],
    );
  }
}
