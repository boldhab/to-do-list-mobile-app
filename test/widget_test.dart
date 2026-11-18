import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:task_planner/app/app.dart';
import 'package:task_planner/app/router/app_router.dart';
import 'package:task_planner/core/widgets/progress_card.dart';
import 'package:task_planner/features/planning/presentation/planner_provider.dart';
import 'package:task_planner/features/planning/data/in_memory_planner_store.dart';
import 'package:task_planner/features/planning/data/planner_service.dart';
import 'package:task_planner/features/planning/domain/planner_snapshot.dart';
import 'package:task_planner/features/tasks/data/mock/sample_tasks.dart';
import 'package:task_planner/features/tasks/domain/entities/task.dart';
import 'package:task_planner/features/tasks/presentation/widgets/task_card.dart';
import 'package:task_planner/features/tasks/presentation/providers/selected_date_provider.dart';

Future<ProviderContainer> openApp(
  WidgetTester tester, {
  String? location,
  DateTime? date,
  Size size = const Size(800, 900),
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final router = buildRouter(initialLocation: location);
  final store = InMemoryPlannerStore(
    PlannerSnapshot(tasks: sampleTasks(DateTime.now())),
  );
  final service = PlannerService(store);
  final container = ProviderContainer(
    overrides: [
      routerProvider.overrideWithValue(router),
      plannerServiceProvider.overrideWithValue(service),
    ],
  );
  addTearDown(store.dispose);
  addTearDown(container.dispose);
  addTearDown(router.dispose);
  if (date != null) container.read(selectedDateProvider.notifier).select(date);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const PlannerApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    150,
    scrollable: find.byType(Scrollable).hitTestable().first,
  );
  await tester.pumpAndSettle();
}

Finder progressValue(String title, String value) => find.descendant(
  of: find.byWidgetPredicate(
    (widget) => widget is ProgressCard && widget.title == title,
  ),
  matching: find.text(value),
);

void main() {
  testWidgets(
    'dashboard reflects completion changes and all tabs route correctly',
    (tester) async {
      await openApp(tester);
      expect(progressValue('Today’s overview', '33%'), findsOneWidget);
      await tap(tester, find.text('Today'));
      expect(find.text('Daily Planner'), findsOneWidget);
      expect(find.text('Draft project outline'), findsOneWidget);
      await tap(
        tester,
        find.byWidgetPredicate(
          (widget) =>
              widget is Checkbox &&
              widget.semanticLabel == 'Complete Draft project outline',
        ),
      );
      expect(progressValue('Daily task progress', '67%'), findsOneWidget);
      await tap(tester, find.text('Pending'));
      expect(find.text('Draft project outline'), findsNothing);
      expect(find.text('Read for 30 minutes'), findsOneWidget);
      await tap(tester, find.text('Home'));
      expect(progressValue('Today’s overview', '67%'), findsOneWidget);
      await tap(tester, find.text('Month'));
      expect(find.text('Monthly Planner'), findsOneWidget);
      await tap(tester, find.text('Week'));
      expect(find.text('Weekly Planner'), findsOneWidget);
      await tap(tester, find.text('Settings'));
      expect(find.text('Appearance'), findsOneWidget);
      await tap(tester, find.text('Dark'));
      expect(
        Theme.of(tester.element(find.text('Appearance'))).brightness,
        Brightness.dark,
      );
      await tap(tester, find.text('Light'));
      expect(
        Theme.of(tester.element(find.text('Appearance'))).brightness,
        Brightness.light,
      );
      await tap(tester, find.text('System'));
      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.system,
      );
    },
  );

  testWidgets(
    'leap-day calendar selection and week controls preserve the selected date',
    (tester) async {
      final container = await openApp(
        tester,
        location: '/monthly',
        date: DateTime(2024, 1),
      );
      await tap(tester, find.byTooltip('Next month'));
      expect(find.text('February 2024'), findsOneWidget);
      await tap(tester, find.text('29'));
      await scrollTo(tester, find.text('Open day'));
      await tap(tester, find.text('Open day'));
      expect(find.text('Daily Planner'), findsOneWidget);
      expect(find.text('February 29, 2024'), findsOneWidget);
      expect(
        find.text('You have a clear day. Add a task to get started.'),
        findsOneWidget,
      );
      await tap(tester, find.text('Week'));
      expect(find.text('Feb 26, 2024 – Mar 3, 2024'), findsOneWidget);
      await tap(tester, find.byTooltip('Next week'));
      expect(container.read(selectedDateProvider), DateTime(2024, 3, 7));
      await tap(tester, find.text('Mon 4'));
      await tap(tester, find.text('Today'));
      expect(find.text('March 4, 2024'), findsOneWidget);
      await tap(tester, find.byTooltip('Previous day'));
      expect(find.text('March 3, 2024'), findsOneWidget);
    },
  );

  testWidgets(
    'empty daily view creates a task, validates title, edits and confirms deletion',
    (tester) async {
      final date = DateTime(2040, 5, 2);
      await openApp(tester, location: '/daily', date: date);
      await tap(tester, find.widgetWithText(FilledButton, 'Add Task'));
      expect(find.text('New Task'), findsOneWidget);
      expect(
        find.text('Scheduled date · ${DateFormat.yMMMd().format(date)}'),
        findsOneWidget,
      );
      await scrollTo(tester, find.text('Save Task'));
      await tap(tester, find.text('Save Task'));
      expect(find.text('Enter a task title.'), findsOneWidget);
      final title = find.byType(TextFormField).first;
      await tester.ensureVisible(title);
      await tester.enterText(title, '  New milestone  ');
      await scrollTo(tester, find.text('Save Task'));
      await tap(tester, find.text('Save Task'));
      expect(find.text('Daily Planner'), findsOneWidget);
      expect(find.text('New milestone'), findsOneWidget);
      await tap(tester, find.byTooltip('Actions for New milestone'));
      await tap(tester, find.text('Edit'));
      expect(find.text('New milestone'), findsOneWidget);
      await tester.enterText(title, 'Updated milestone');
      await scrollTo(tester, find.text('Save Task'));
      await tap(tester, find.text('Save Task'));
      await tap(tester, find.byTooltip('Actions for Updated milestone'));
      await tap(tester, find.text('Delete'));
      expect(find.text('Delete task?'), findsOneWidget);
      await tap(tester, find.text('Cancel'));
      expect(find.text('Updated milestone'), findsOneWidget);
      await tap(tester, find.byTooltip('Actions for Updated milestone'));
      await tap(tester, find.text('Delete'));
      await tap(tester, find.text('Delete'));
      expect(find.text('Updated milestone'), findsNothing);
      expect(
        find.text('You have a clear day. Add a task to get started.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('compact layout supports large text and system back', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openApp(tester, size: const Size(320, 640));
    expect(find.text('Task Planner'), findsOneWidget);
    await tap(tester, find.text('Month'));
    expect(find.text('Monthly Planner'), findsOneWidget);
    await tap(tester, find.text('Week'));
    expect(find.text('Weekly Planner'), findsOneWidget);
    await tap(tester, find.text('Today'));
    final add = find.widgetWithText(FilledButton, 'Add Task');
    await scrollTo(tester, add);
    await tap(tester, add);
    expect(find.text('New Task'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Daily Planner'), findsOneWidget);
    await tap(tester, find.text('Settings'));
    expect(find.text('Appearance'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('goal editors validate and navigate through the full hierarchy', (
    tester,
  ) async {
    final container = await openApp(tester, size: const Size(800, 1050));
    final service = container.read(plannerServiceProvider) as PlannerService;
    await tap(tester, find.text('Add Monthly Goal'));
    await tap(tester, find.text('Save Goal'));
    expect(find.text('Enter a title.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Release plan');
    await tester.enterText(find.byType(TextFormField).at(2), '0');
    await tap(tester, find.text('Save Goal'));
    expect(find.text('Enter a year from 1 to 9999.'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).at(2),
      DateTime.now().year.toString(),
    );
    await tap(tester, find.text('Save Goal'));
    final monthly = service.monthly.items.single;
    expect(monthly.title, 'Release plan');
    await tap(tester, find.text('Month'));
    await scrollTo(tester, find.text('Release plan'));
    await tap(tester, find.text('Release plan'));
    expect(find.text('Monthly Goal'), findsOneWidget);
    await tap(tester, find.text('Add Weekly Goal'));
    await tap(tester, find.text('Save Goal'));
    expect(find.text('Enter a title.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Finish flow');
    await tap(tester, find.text('Save Goal'));
    expect(service.weekly.items.single.monthlyGoalId, monthly.id);
    await tap(tester, find.text('Finish flow'));
    expect(find.text('Weekly Goal'), findsOneWidget);
    await tap(tester, find.text('Add Daily Task'));
    await tester.enterText(
      find.byType(TextFormField).first,
      'Review hierarchy',
    );
    await scrollTo(tester, find.text('Save Task'));
    await tap(tester, find.text('Save Task'));
    final task = service.tasks.items.singleWhere(
      (task) => task.title == 'Review hierarchy',
    );
    expect(task.weeklyGoalId, service.weekly.items.single.id);
    expect(progressValue('Linked task completion', '0%'), findsOneWidget);
    await tap(
      tester,
      find.byWidgetPredicate(
        (widget) =>
            widget is Checkbox &&
            widget.semanticLabel == 'Complete Review hierarchy',
      ),
    );
    expect(progressValue('Linked task completion', '100%'), findsOneWidget);
    expect(find.text('Goal open'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(progressValue('Linked task completion', '100%'), findsOneWidget);

    await tap(tester, find.text('Delete Goal'));
    await tap(tester, find.text('Cancel'));
    expect(service.monthly.items.single.id, monthly.id);
    await tap(tester, find.text('Delete Goal'));
    await tap(tester, find.text('Keep weekly goals'));
    expect(service.monthly.items, isEmpty);
    expect(service.weekly.items.single.monthlyGoalId, isNull);
    expect(service.tasks.require(task.id).isCompleted, isTrue);
  });

  testWidgets(
    'task editor validates association and allows selecting an independent task',
    (tester) async {
      final date = DateTime(2040, 5, 2);
      final container = await openApp(
        tester,
        location: '/daily',
        date: date,
        size: const Size(800, 1050),
      );
      final service = container.read(plannerServiceProvider) as PlannerService;
      service.saveWeekly(
        title: 'Different week',
        weekStart: DateTime(2040, 5, 7),
        completed: false,
      );
      await tester.pumpAndSettle();
      await tap(tester, find.widgetWithText(FilledButton, 'Add Task'));
      await tester.enterText(
        find.byType(TextFormField).first,
        'Independent item',
      );
      final selector = find.byType(DropdownButtonFormField<String>);
      await tap(tester, selector);
      await tap(tester, find.textContaining('Different week').last);
      await scrollTo(tester, find.text('Save Task'));
      await tap(tester, find.text('Save Task'));
      expect(
        find.text('Choose a scheduled date in this goal’s week, or unlink it.'),
        findsOneWidget,
      );
      expect(
        service.tasks.items.where((task) => task.title == 'Independent item'),
        isEmpty,
      );
      await tester.ensureVisible(selector);
      await tap(tester, selector);
      await tap(tester, find.text('Independent').last);
      await scrollTo(tester, find.text('Save Task'));
      await tap(tester, find.text('Save Task'));
      final task = service.tasks.items.singleWhere(
        (task) => task.title == 'Independent item',
      );
      expect(task.weeklyGoalId, isNull);
      expect(task.priority, TaskPriority.medium);
    },
  );

  testWidgets('weekly editor asks before moving child tasks in dark mode', (
    tester,
  ) async {
    final date = DateTime(2040, 5, 2);
    final container = await openApp(
      tester,
      location: '/weekly',
      date: date,
      size: const Size(800, 1050),
    );
    final service = container.read(plannerServiceProvider) as PlannerService;
    final goal = service.saveWeekly(
      title: 'Move a week',
      weekStart: DateTime(2040, 4, 30),
      completed: false,
    );
    final child = service.saveTask(
      title: 'Keep my weekday',
      date: date,
      priority: TaskPriority.high,
      completed: false,
      weeklyGoalId: goal.id,
    );
    await tester.pumpAndSettle();
    await tap(tester, find.text('Settings'));
    await tap(tester, find.text('Dark'));
    await tap(tester, find.text('Week'));
    await scrollTo(tester, find.text('Move a week'));
    await tap(tester, find.text('Move a week'));
    expect(
      Theme.of(tester.element(find.text('Weekly Goal'))).brightness,
      Brightness.dark,
    );
    await tap(tester, find.text('Edit Goal'));
    await tap(
      tester,
      find.widgetWithText(OutlinedButton, 'Apr 30, 2040 – May 6, 2040'),
    );
    final picker = find.byType(DatePickerDialog);
    await tap(
      tester,
      find.descendant(of: picker, matching: find.byIcon(Icons.edit_outlined)),
    );
    await tester.enterText(
      find.descendant(of: picker, matching: find.byType(TextFormField)),
      '05/09/2040',
    );
    await tap(tester, find.descendant(of: picker, matching: find.text('OK')));
    await tap(tester, find.text('Save Goal'));
    final moveDialog = find.byType(AlertDialog);
    expect(find.text('Move this weekly goal?'), findsOneWidget);
    await tap(
      tester,
      find.descendant(of: moveDialog, matching: find.text('Cancel')),
    );
    expect(service.tasks.require(child.id).scheduledDate, date);
    await tap(tester, find.text('Save Goal'));
    await tap(tester, find.text('Reschedule tasks'));
    expect(service.tasks.require(child.id).scheduledDate, DateTime(2040, 5, 9));
    expect(service.tasks.require(child.id).weeklyGoalId, goal.id);
    expect(find.text('Keep my weekday'), findsOneWidget);
  });

  testWidgets('missing goal deep link has a recovery action', (tester) async {
    await openApp(tester, location: '/weekly/goals/deleted');
    expect(find.text('This goal could not be found.'), findsOneWidget);
    await tap(tester, find.text('Back to planner'));
    expect(find.text('Weekly Planner'), findsOneWidget);
  });

  testWidgets(
    'global search normalizes the query and clears to all matching tasks',
    (tester) async {
      await openApp(tester, location: '/search', size: const Size(800, 1050));
      expect(find.text('Draft project outline'), findsOneWidget);
      final field = find.byType(TextField);
      await tester.enterText(field, '  DRAFT    OUTLINE ');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.text('1 matches'), findsOneWidget);
      expect(find.text('Draft project outline'), findsOneWidget);
      expect(find.text('Review weekly priorities'), findsNothing);
      await tester.enterText(field, 'unmatched task');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('No tasks match these filters'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'analytics displays real daily completion and the interactive calendar switches views',
    (tester) async {
      final container = await openApp(tester, size: const Size(800, 1050));
      await tap(tester, find.text('Analytics'));
      await tap(tester, find.text('Today'));
      expect(progressValue('Scheduled task completion', '33%'), findsOneWidget);
      await tap(tester, find.text('View chart values'));
      expect(find.text('1 completed of 3 planned'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tap(tester, find.text('Month'));
      await tap(tester, find.text('Week view'));
      expect(find.byTooltip('Next week'), findsOneWidget);
      await tap(tester, find.byTooltip('Next week'));
      final future = container.read(selectedDateProvider);
      await tap(tester, find.text('Jump to today'));
      expect(container.read(selectedDateProvider).isBefore(future), isTrue);
    },
  );

  testWidgets('Daily renders a small window when 10,000 tasks share one date', (
    tester,
  ) async {
    final day = DateTime(2045, 1, 1);
    final container = await openApp(tester, location: '/daily', date: day);
    final service = container.read(plannerServiceProvider) as PlannerService;
    service.store.commit(
      PlannerSnapshot(
        tasks: [
          for (var index = 0; index < 10000; index++)
            PlannerTask(
              id: 'task-${index.toString().padLeft(5, '0')}',
              title: 'Fixture $index',
              scheduledDate: day,
              priority: TaskPriority.medium,
              createdAt: day,
              updatedAt: day,
            ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('10000 total'), findsOneWidget);
    expect(find.byType(TaskListItem).evaluate().length, lessThan(50));
    await tester.scrollUntilVisible(
      find.text('Fixture 25'),
      500,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    expect(find.text('Fixture 25'), findsOneWidget);
    expect(find.byType(TaskListItem).evaluate().length, lessThan(50));
  });

  for (final (name, size) in [
    ('compact landscape', const Size(640, 320)),
    ('tablet', const Size(1024, 768)),
  ]) {
    testWidgets('$name retains navigation and Settings privacy at 200% text', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await openApp(tester, size: size);
      await tap(tester, find.text('Month'));
      expect(find.text('Monthly Planner'), findsOneWidget);
      await tap(tester, find.text('Week'));
      expect(find.text('Weekly Planner'), findsOneWidget);
      await tap(tester, find.text('Settings'));
      await scrollTo(tester, find.text('Privacy policy'));
      await tap(tester, find.text('Privacy policy'));
      expect(find.text('Task Planner privacy policy'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Settings shows the installed version reported by Android', (
    tester,
  ) async {
    const channel = MethodChannel('task_planner/app_info');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      channel,
      (call) async => call.method == 'version' ? '1.0.0 (2)' : null,
    );
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    await openApp(tester, location: '/settings');
    expect(find.textContaining('Version 1.0.0 (2)'), findsOneWidget);
  });

  testWidgets('unknown routes recover to the dashboard', (tester) async {
    await openApp(tester, location: '/missing-route');
    expect(find.text('Page unavailable'), findsOneWidget);
    await tap(tester, find.text('Go home'));
    expect(find.text('Today’s overview'), findsOneWidget);
  });
}
