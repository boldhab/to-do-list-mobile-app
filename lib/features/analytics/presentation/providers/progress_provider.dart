import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/progress_calculator.dart';
import '../../../tasks/presentation/providers/task_query_provider.dart';

final periodProgressProvider = Provider.autoDispose
    .family<TaskProgress, DateRange>(
      (ref, range) => TaskProgress(
        ref.watch(tasksInPeriodProvider(range)).asData?.value ?? const [],
      ),
    );
final weeklyGoalProgressProvider = Provider.autoDispose
    .family<TaskProgress, String>(
      (ref, id) => TaskProgress(
        ref.watch(tasksForWeeklyGoalProvider(id)).asData?.value ?? const [],
      ),
    );
final monthlyGoalProgressProvider = Provider.autoDispose
    .family<TaskProgress, String>(
      (ref, id) => TaskProgress(
        ref.watch(tasksForMonthlyGoalProvider(id)).asData?.value ?? const [],
      ),
    );
