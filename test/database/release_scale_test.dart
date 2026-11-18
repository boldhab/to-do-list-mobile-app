import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_planner/core/database/app_database.dart';
import 'package:task_planner/core/database/database_provider.dart';
import 'package:task_planner/core/database/date_storage.dart';
import 'package:task_planner/core/utils/date_helpers.dart';
import 'package:task_planner/features/analytics/domain/productivity_metrics.dart';
import 'package:task_planner/features/productivity/data/productivity_store.dart';
import 'package:task_planner/features/search/domain/task_search.dart';

void main() {
  for (final count in [100, 1000, 10000]) {
    test('calendar, search and analytics work with $count persisted tasks', () async {
      final database = AppDatabase(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
      );
      addTearDown(() async {
        container.dispose();
        await database.close();
      });
      final store = container.read(productivityStoreProvider);
      final today = DateTime(2026, 11, 18);
      await database.batch(
        (batch) => batch.insertAll(database.tasks, [
          for (var index = 0; index < count; index++)
            TasksCompanion.insert(
              id: 'task-$index',
              title: index.isEven ? 'Plan review' : 'Write notes',
              scheduledDate: encodeDay(shiftDay(today, index % 100)),
              priority: 'medium',
              createdAt: today.toUtc(),
              updatedAt: today.toUtc(),
            ),
        ]),
      );
      final from = shiftDay(today, 1);
      final through = shiftDay(today, 7);
      final calendarMicros = <int>[];
      final searchMicros = <int>[];
      for (var sample = 0; sample < 6; sample++) {
        final stopwatch = Stopwatch()..start();
        final calendar = await store.forRange(from, through);
        calendarMicros.add(stopwatch.elapsedMicroseconds);
        expect(calendar, hasLength(count ~/ 100 * 7));
        final all = await store.forRange(today, null);
        stopwatch.reset();
        final matches = filterAndSortTasks(
          all,
          'review',
          defaultSearchFilters,
          today,
          {},
        );
        searchMicros.add(stopwatch.elapsedMicroseconds);
        expect(matches, hasLength(count ~/ 2));
        expect(
          performanceBuckets(
            calendar,
            from,
            through,
          ).fold<int>(0, (total, bucket) => total + bucket.planned),
          calendar.length,
        );
      }
      int median(List<int> values) {
        final warm = values.skip(1).toList()..sort();
        return warm[warm.length ~/ 2];
      }

      // Informational measurements, never a timing threshold.
      // ignore: avoid_print
      print(
        'records=$count calendar_us=${median(calendarMicros)} search_us=${median(searchMicros)}',
      );
    });
  }
}
