import 'dart:io';

import 'package:drift/drift.dart' show LazyDatabase;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_planner/app/app.dart';
import 'package:task_planner/app/router/app_router.dart';
import 'package:task_planner/core/database/app_database.dart';
import 'package:task_planner/core/database/database_provider.dart';
import 'package:task_planner/features/planning/presentation/planner_provider.dart';
import 'package:task_planner/features/tasks/domain/entities/task.dart';
import 'package:task_planner/features/tasks/presentation/providers/selected_date_provider.dart';

Future<void> pumpUntil(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 90 && finder.evaluate().isEmpty; attempt++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  expect(finder, findsWidgets);
}

void main() {
  testWidgets('database open failure shows a safe retry and recovers', (
    tester,
  ) async {
    var attempts = 0;
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWith((ref) {
          final database = ++attempts == 1
              ? _FailingDatabase()
              : AppDatabase(NativeDatabase.memory());
          ref.onDispose(database.dispose);
          return database;
        }),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PlannerApp(),
      ),
    );
    final retry = find.text('Retry');
    await pumpUntil(tester, retry);
    expect(find.textContaining('PRIVATE_DIAGNOSTIC'), findsNothing);
    await tester.tap(retry);
    await pumpUntil(tester, find.text('Task Planner'));
    expect(attempts, 2);
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets(
    'a reopened file populates Daily Planner and persists completion',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final date = DateTime(2025, 1, 2);
      final directory = await tester.runAsync(
        () => Directory.systemTemp.createTemp('planner-ui-'),
      );
      addTearDown(() => directory!.delete(recursive: true));
      final file = File('${directory!.path}/planner.sqlite');
      await tester.runAsync(() async {
        final first = AppDatabase(NativeDatabase(file));
        final container = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(first)],
        );
        try {
          await container
              .read(plannerServiceProvider)
              .saveTask(
                title: 'Reopened task',
                date: date,
                priority: TaskPriority.high,
                completed: false,
              );
        } finally {
          container.dispose();
          await first.close();
        }
      });
      final database = AppDatabase(NativeDatabase(file));

      final router = buildRouter(initialLocation: '/daily');
      addTearDown(router.dispose);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          routerProvider.overrideWithValue(router),
        ],
      );
      container.read(selectedDateProvider.notifier).select(date);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const PlannerApp(),
        ),
      );
      await pumpUntil(tester, find.text('Reopened task'));
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is Checkbox &&
              widget.semanticLabel == 'Complete Reopened task',
        ),
      );
      await pumpUntil(tester, find.text('100%'));
      await tester.pumpWidget(const SizedBox());
      container.dispose();
      await tester.pump();
      var closed = false;
      final closing = database.close().then((_) => closed = true);
      for (var attempt = 0; attempt < 20 && !closed; attempt++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(closed, isTrue);
      await closing;
    },
  );
}

class _FailingDatabase extends AppDatabase {
  _FailingDatabase()
    : super(LazyDatabase(() async => throw StateError('PRIVATE_DIAGNOSTIC')));
}
