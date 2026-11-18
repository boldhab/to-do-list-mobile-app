import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_helpers.dart';
import '../../../planning/presentation/planner_provider.dart';
import '../../../tasks/presentation/providers/selected_date_provider.dart';
import '../../domain/entities/monthly_goal.dart';

final monthlyGoalsProvider = Provider<List<MonthlyGoal>>(
  (ref) =>
      ref.watch(
        plannerLoadProvider.select((state) => state.asData?.value.monthly),
      ) ??
      const [],
);
final selectedMonthProvider = Provider<DateTime>(
  (ref) => shiftMonth(ref.watch(selectedDateProvider), 0),
);
final monthlyGoalProvider = Provider.autoDispose.family<MonthlyGoal?, String>(
  (ref, id) => ref
      .watch(monthlyGoalsProvider)
      .where((goal) => goal.id == id)
      .firstOrNull,
);
