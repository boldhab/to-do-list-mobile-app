import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../planning/presentation/planner_feedback.dart';
import '../../../weekly_planner/presentation/providers/weekly_goal_provider.dart';
import '../../domain/entities/task.dart';
import '../providers/selected_date_provider.dart';
import '../providers/task_provider.dart';
import '../providers/task_query_provider.dart';
import '../../../planning/presentation/planner_provider.dart';
import '../../../planning/presentation/planner_query_status.dart';
import '../widgets/task_form.dart';
import '../../../productivity/data/preferences.dart';
import '../../../productivity/data/productivity_store.dart';
import '../../../productivity/presentation/task_options_form.dart';
import '../../../reminders/presentation/reminder_provider.dart';

final _taskOptionsProvider = StreamProvider.autoDispose
    .family<TaskOptions, String>(
      (ref, id) => ref.watch(productivityStoreProvider).watchOptions(id),
    );

class TaskEditorScreen extends ConsumerWidget {
  const TaskEditorScreen({
    super.key,
    this.id,
    this.defaultDate,
    this.weeklyGoalId,
    this.reschedule = false,
  });
  final String? id;
  final DateTime? defaultDate;
  final String? weeklyGoalId;
  final bool reschedule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = id == null ? null : ref.watch(taskByIdProvider(id!));
    final task = query?.asData?.value;
    final selected = ref.watch(selectedDateProvider);
    final advanced = !ref.watch(usesPlannerFixtureProvider);
    final options = advanced && id != null && task != null
        ? ref.watch(_taskOptionsProvider(id!))
        : null;
    final initialDate = task?.scheduledDate ?? defaultDate ?? selected;
    return PlannerPage(
      title: id == null ? 'New Task' : 'Edit Task',
      children: [
        if (query != null && query.asData == null)
          PlannerQueryStatus(query)
        else if (id != null && task == null) ...[
          const EmptyState('This task could not be found.'),
          OutlinedButton(
            onPressed: () => returnToPlanner(context, RouteNames.daily),
            child: const Text('Back to planner'),
          ),
        ] else if (options != null && options.asData == null)
          PlannerQueryStatus(options)
        else
          TaskForm(
            task: task,
            pickDateOnOpen: reschedule,
            enableAdvanced: advanced,
            options: options?.asData?.value ?? emptyTaskOptions,
            defaultOffset: ref.watch(preferencesProvider).reminderOffset,
            permission: advanced
                ? ref.watch(reminderControllerProvider)
                : PermissionStatus.unavailable,
            requestPermission: () => ref
                .read(reminderControllerProvider.notifier)
                .requestPermission(),
            weeklyGoalId: weeklyGoalId,
            goals: ref.watch(weeklyGoalsProvider),
            initialDate: initialDate,
            onSave:
                (
                  title,
                  description,
                  date,
                  priority,
                  completed,
                  dueAt,
                  goalId,
                  options,
                ) async {
                  final saved = await runPlannerAction(
                    context,
                    () async {
                      if (advanced) {
                        await ref.read(productivityStoreProvider).save(id, (
                          title: title,
                          description: description,
                          date: date,
                          priority: priority,
                          completed: completed,
                          dueAt: dueAt,
                          goalId: goalId,
                        ), options);
                      } else {
                        await ref
                            .read(plannerServiceProvider)
                            .saveTask(
                              id: id,
                              title: title,
                              description: description,
                              date: date,
                              priority: priority,
                              completed: completed,
                              dueAt: dueAt,
                              weeklyGoalId: goalId,
                            );
                      }
                    },
                    options.reminder != null &&
                            ref.read(reminderControllerProvider) !=
                                PermissionStatus.allowed
                        ? 'Task saved. The reminder needs notification permission.'
                        : reschedule
                        ? 'Task rescheduled.'
                        : 'Task saved.',
                    failure: 'Unable to save task. Please try again.',
                  );
                  if (!saved || !context.mounted) return;
                  final canReturn = context.canPop();
                  if (!sameDay(date, initialDate) || !canReturn) {
                    ref.read(selectedDateProvider.notifier).select(date);
                  }
                  final filter = ref.read(taskFilterProvider);
                  if ((filter == TaskFilter.pending && completed) ||
                      (filter == TaskFilter.completed && !completed) ||
                      (filter == TaskFilter.highPriority &&
                          priority != TaskPriority.high)) {
                    ref
                        .read(taskFilterProvider.notifier)
                        .select(TaskFilter.all);
                  }
                  final goalFilter = ref.read(taskGoalFilterProvider);
                  if (goalFilter != null && goalFilter != goalId) {
                    ref.read(taskGoalFilterProvider.notifier).select(null);
                  }
                  if (canReturn) {
                    context.pop();
                  } else {
                    context.go(RouteNames.daily);
                  }
                },
          ),
      ],
    );
  }
}
