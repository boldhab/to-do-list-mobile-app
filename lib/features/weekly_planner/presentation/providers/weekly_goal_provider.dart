import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_helpers.dart';
import '../../../planning/presentation/planner_provider.dart';
import '../../../tasks/presentation/providers/selected_date_provider.dart';
import '../../domain/entities/weekly_goal.dart';

final weeklyGoalsProvider = Provider<List<WeeklyGoal>>(
  (ref) =>
      ref.watch(
        plannerLoadProvider.select((state) => state.asData?.value.weekly),
      ) ??
      const [],
);
final selectedWeekProvider = Provider<DateTime>(
  (ref) => mondayOf(ref.watch(selectedDateProvider)),
);
final weeklyGoalProvider = Provider.autoDispose.family<WeeklyGoal?, String>(
  (ref, id) =>
      ref.watch(weeklyGoalsProvider).where((goal) => goal.id == id).firstOrNull,
);
