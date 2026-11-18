import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../core/utils/progress_calculator.dart';
import '../../../analytics/domain/progress_service.dart';
import '../../../planning/presentation/planner_provider.dart';
import '../../domain/entities/task.dart';
import '../../../productivity/data/productivity_store.dart';

export '../../../../core/utils/date_helpers.dart' show DateRange;

final _range = StreamProvider.autoDispose.family<List<PlannerTask>, DateRange>(
  (ref, range) =>
      ref.watch(productivityStoreProvider).watchRange(range.start, range.end),
);
final _id = StreamProvider.autoDispose.family<PlannerTask?, String>(
  (ref, id) => ref.watch(productivityStoreProvider).watchTask(id),
);
final _weekly = StreamProvider.autoDispose.family<List<PlannerTask>, String>(
  (ref, id) => ref.watch(taskRepositoryProvider).watchForWeeklyGoal(id),
);
final _monthly = StreamProvider.autoDispose.family<List<PlannerTask>, String>(
  (ref, id) => ref.watch(taskRepositoryProvider).watchForMonthlyGoal(id),
);
final _upcoming = StreamProvider.autoDispose
    .family<List<PlannerTask>, DateTime>(
      (ref, start) => ref.watch(productivityStoreProvider).watchUpcoming(start),
    );

final tasksInPeriodProvider = Provider.autoDispose
    .family<AsyncValue<List<PlannerTask>>, DateRange>(
      (ref, range) => ref.watch(usesPlannerFixtureProvider)
          ? AsyncData(
              tasksBetween(
                ref.watch(plannerProvider).tasks,
                range.start,
                range.end,
              ),
            )
          : ref.watch(_range(range)),
    );

final taskByIdProvider = Provider.autoDispose
    .family<AsyncValue<PlannerTask?>, String>(
      (ref, id) => ref.watch(usesPlannerFixtureProvider)
          ? AsyncData(
              ref
                  .watch(plannerProvider)
                  .tasks
                  .where((task) => task.id == id)
                  .firstOrNull,
            )
          : ref.watch(_id(id)),
    );

final tasksForWeeklyGoalProvider = Provider.autoDispose
    .family<AsyncValue<List<PlannerTask>>, String>(
      (ref, id) => ref.watch(usesPlannerFixtureProvider)
          ? AsyncData(tasksForWeeklyGoals(ref.watch(plannerProvider), {id}))
          : ref.watch(_weekly(id)),
    );

final tasksForMonthlyGoalProvider = Provider.autoDispose
    .family<AsyncValue<List<PlannerTask>>, String>((ref, id) {
      if (!ref.watch(usesPlannerFixtureProvider)) {
        return ref.watch(_monthly(id));
      }
      final snapshot = ref.watch(plannerProvider);
      final ids = snapshot.weekly
          .where((goal) => goal.monthlyGoalId == id)
          .map((goal) => goal.id)
          .toSet();
      return AsyncData(tasksForWeeklyGoals(snapshot, ids));
    });

final upcomingTasksProvider = Provider.autoDispose
    .family<AsyncValue<List<PlannerTask>>, DateTime>(
      (ref, start) => ref.watch(usesPlannerFixtureProvider)
          ? AsyncData(
              ref
                  .watch(plannerProvider)
                  .tasks
                  .where(
                    (task) =>
                        !task.isCompleted &&
                        !task.scheduledDate.isBefore(start),
                  )
                  .toList(),
            )
          : ref.watch(_upcoming(start)),
    );
