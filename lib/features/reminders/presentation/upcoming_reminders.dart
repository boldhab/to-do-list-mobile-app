import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/route_names.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/widgets/section_header.dart';
import '../../planning/presentation/planner_provider.dart';
import '../../tasks/presentation/providers/task_query_provider.dart';

final _deliveries = StreamProvider.autoDispose<List<DeliveryRow>>((ref) {
  if (ref.watch(usesPlannerFixtureProvider)) return Stream.value(const []);
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.reminderDeliveries)
        ..orderBy([(row) => OrderingTerm.asc(row.fireAt)])
        ..limit(5))
      .watch();
});

class UpcomingReminders extends ConsumerWidget {
  const UpcomingReminders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(_deliveries);
    final reminders = query.asData?.value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('Upcoming reminders'),
        if (query.hasError)
          const Text('Unable to load reminder status.')
        else if (query.isLoading)
          const LinearProgressIndicator()
        else if (reminders.isEmpty)
          const Text('No reminders in the scheduling window.'),
        for (final item in reminders)
          Consumer(
            builder: (context, ref, _) {
              final task = ref
                  .watch(taskByIdProvider(item.taskId))
                  .asData
                  ?.value;
              return ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: Text(task?.title ?? 'Task reminder'),
                subtitle: Text(
                  '${DateFormat.yMMMd().add_jm().format(item.fireAt.toLocal())} · ${switch (item.state) {
                    'scheduled' => 'Scheduled with Android',
                    'permission' => 'Needs notification permission',
                    'failed' => 'Scheduling failed. The app will retry.',
                    _ => 'Waiting to schedule',
                  }}',
                ),
                onTap: () => context.push(RouteNames.edit(item.taskId)),
              );
            },
          ),
      ],
    );
  }
}
