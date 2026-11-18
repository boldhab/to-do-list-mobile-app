import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_state.dart';
import 'planner_provider.dart';

class PlannerQueryStatus extends ConsumerWidget {
  const PlannerQueryStatus(this.query, {super.key});

  final AsyncValue<Object?> query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.hasError) {
      return Column(
        children: [
          const EmptyState('Unable to load your tasks.'),
          TextButton(
            onPressed: () => retryPlannerLoad(ref),
            child: const Text('Retry'),
          ),
        ],
      );
    }
    if (query.isLoading) {
      return const Center(
        child: CircularProgressIndicator(semanticsLabel: 'Loading tasks'),
      );
    }
    return const SizedBox.shrink();
  }
}
