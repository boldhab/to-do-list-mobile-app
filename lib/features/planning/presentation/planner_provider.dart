import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/drift_planner_service.dart';
import '../data/planner_service.dart';
import '../domain/planner_snapshot.dart';

final driftPlannerServiceProvider = Provider<DriftPlannerService>(
  (ref) => DriftPlannerService(
    ref.watch(appDatabaseProvider),
    ref.watch(monthlyRepositoryProvider),
    ref.watch(weeklyRepositoryProvider),
    ref.watch(taskRepositoryProvider),
  ),
);

final plannerServiceProvider = Provider<PlannerCommands>(
  (ref) => ref.watch(driftPlannerServiceProvider),
);

final _storedGoalsProvider = StreamProvider<PlannerSnapshot>(
  (ref) => ref.watch(driftPlannerServiceProvider).watchAll(includeTasks: false),
);

final _storedPlannerProvider = StreamProvider<PlannerSnapshot>(
  (ref) => ref.watch(driftPlannerServiceProvider).watchAll(),
);

final usesPlannerFixtureProvider = Provider<bool>(
  (ref) => ref.watch(plannerServiceProvider) is PlannerService,
);

final _fixturePlannerProvider =
    NotifierProvider<_FixturePlanner, PlannerSnapshot>(_FixturePlanner.new);

class _FixturePlanner extends Notifier<PlannerSnapshot> {
  @override
  PlannerSnapshot build() {
    final store = (ref.watch(plannerServiceProvider) as PlannerService).store;
    final subscription = store.updates.listen((snapshot) => state = snapshot);
    ref.onDispose(() => unawaited(subscription.cancel()));
    return store.snapshot;
  }
}

final plannerLoadProvider = Provider<AsyncValue<PlannerSnapshot>>((ref) {
  if (ref.watch(usesPlannerFixtureProvider)) {
    return AsyncData(ref.watch(_fixturePlannerProvider));
  }
  return ref.watch(_storedGoalsProvider);
});

final _empty = PlannerSnapshot();

final plannerProvider = Provider<PlannerSnapshot>(
  (ref) => ref.watch(usesPlannerFixtureProvider)
      ? ref.watch(_fixturePlannerProvider)
      : ref.watch(_storedPlannerProvider).asData?.value ?? _empty,
);

void retryPlannerLoad(WidgetRef ref) {
  ref.invalidate(appDatabaseProvider);
  ref.invalidate(_storedGoalsProvider);
}
