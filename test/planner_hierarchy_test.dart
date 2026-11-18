import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_planner/core/errors/planner_exception.dart';
import 'package:task_planner/core/utils/date_helpers.dart';
import 'package:task_planner/features/analytics/domain/progress_service.dart';
import 'package:task_planner/features/analytics/presentation/providers/progress_provider.dart';
import 'package:task_planner/features/planning/data/in_memory_planner_store.dart';
import 'package:task_planner/features/planning/data/planner_service.dart';
import 'package:task_planner/features/planning/domain/planner_snapshot.dart';
import 'package:task_planner/features/planning/presentation/planner_provider.dart';
import 'package:task_planner/features/tasks/domain/entities/task.dart';
import 'package:task_planner/features/tasks/presentation/providers/task_provider.dart';

void main() {
  late InMemoryPlannerStore store;
  late PlannerService service;
  final monday = DateTime(2026, 11, 30);
  final tuesday = DateTime(2026, 12);

  setUp(() {
    store = InMemoryPlannerStore(PlannerSnapshot());
    service = PlannerService(store);
    addTearDown(store.dispose);
  });

  String month({String title = 'Ship', int month = 12, int year = 2026}) =>
      service
          .saveMonthly(title: title, year: year, month: month, completed: false)
          .id;

  String week({String? parent, DateTime? start, String title = 'Build'}) =>
      service
          .saveWeekly(
            title: title,
            weekStart: start ?? monday,
            monthlyGoalId: parent,
            completed: false,
          )
          .id;

  PlannerTask task({
    String? parent,
    DateTime? date,
    String title = 'Write',
    TaskPriority priority = TaskPriority.medium,
    DateTime? deadline,
    bool completed = false,
  }) => service.saveTask(
    title: title,
    date: date ?? tuesday,
    priority: priority,
    completed: completed,
    weeklyGoalId: parent,
    dueAt: deadline,
  );

  test(
    'monthly validation, editing, toggling and deletion without children',
    () {
      expect(() => month(title: '  '), throwsA(isA<PlannerException>()));
      expect(() => month(month: 13), throwsA(isA<PlannerException>()));
      expect(() => month(year: 0), throwsA(isA<PlannerException>()));
      final id = month();
      final original = service.monthly.require(id);
      final updated = service.saveMonthly(
        id: id,
        title: ' Updated ',
        description: ' Details ',
        year: 2027,
        month: 1,
        completed: false,
      );
      expect(updated.title, 'Updated');
      expect(updated.description, 'Details');
      expect(updated.createdAt, original.createdAt);
      expect(updated, updated.copyWith());
      service.toggleMonthly(id);
      expect(service.monthly.require(id).isCompleted, isTrue);
      service.toggleMonthly(id);
      service.deleteMonthly(id, DeletePolicy.preserve);
      expect(service.monthly.find(id), isNull);
      expect(() => service.toggleMonthly(id), throwsA(isA<PlannerException>()));
    },
  );

  test('weekly goals link by ID across month boundaries and can be reassigned and unlinked', () {
    final december = month();
    final november = month(month: 11);
    expect(() => week(parent: 'missing'), throwsA(isA<PlannerException>()));
    expect(() => week(start: tuesday), throwsA(isA<PlannerException>()));
    final id = week(parent: december);
    expect(service.weekly.require(id).weekEnd, DateTime(2026, 12, 6));

    void assign(String? parent) => service.saveWeekly(
      id: id,
      title: 'Build',
      weekStart: monday,
      monthlyGoalId: parent,
      completed: false,
    );
    assign(november);
    expect(service.weekly.require(id).monthlyGoalId, november);
    assign(null);
    expect(service.weekly.require(id).monthlyGoalId, isNull);
    service.toggleWeekly(id);
    expect(service.weekly.require(id).isCompleted, isTrue);
    service.toggleWeekly(id);
    expect(service.weekly.require(id).isCompleted, isFalse);
  });

  test('task association and timestamps stay valid through completion and reassignment', () {
    final first = week();
    final nextMonday = shiftDay(monday, 7);
    final next = week(start: nextMonday, title: 'Verify');
    final original = task(deadline: DateTime(2026, 12, 1, 17));
    expect(original.weeklyGoalId, isNull);
    PlannerTask edit(String? parent, DateTime date, {bool completed = false}) =>
        service.saveTask(
          id: original.id,
          title: 'Edited',
          date: date,
          priority: original.priority,
          completed: completed,
          weeklyGoalId: parent,
          dueAt: original.dueAt,
        );
    expect(() => edit('missing', tuesday), throwsA(isA<PlannerException>()));
    expect(() => edit(next, tuesday), throwsA(isA<PlannerException>()));
    expect(
      () => task(parent: first, date: nextMonday),
      throwsA(isA<PlannerException>()),
    );
    expect(service.tasks.require(original.id), original);
    expect(edit(first, tuesday).weeklyGoalId, first);
    service.toggleTask(original.id);
    final completion = service.tasks.require(original.id).completedAt;
    expect(completion, isNotNull);
    final moved = edit(next, nextMonday, completed: true);
    expect(moved.completedAt, completion);
    expect(moved.scheduledDate, nextMonday);
    expect(moved.weeklyGoalId, next);
    service.toggleTask(original.id);
    expect(service.tasks.require(original.id).completedAt, isNull);
    expect(edit(null, nextMonday).weeklyGoalId, isNull);
    service.tasks.remove(original.id);
    expect(service.tasks.items, isEmpty);
  });

  test('moving a weekly goal requires an explicit, atomic child policy', () {
    final id = week();
    final child = task(parent: id, deadline: DateTime(2026, 12, 4));
    final nextMonday = shiftDay(monday, 7);
    void move(DateTime start, [WeekMovePolicy? policy]) => service.saveWeekly(
      id: id,
      title: 'Move',
      weekStart: start,
      completed: false,
      move: policy,
    );
    final before = store.snapshot;
    expect(() => move(nextMonday), throwsA(isA<PlannerException>()));
    expect(store.snapshot, same(before));
    final updates = <PlannerSnapshot>[];
    final subscription = store.updates.listen(updates.add);
    addTearDown(subscription.cancel);
    move(nextMonday, WeekMovePolicy.reschedule);
    expect(updates, hasLength(1));
    final shifted = service.tasks.require(child.id);
    expect(shifted.scheduledDate, shiftDay(child.scheduledDate, 7));
    expect(shifted.dueAt, child.dueAt);
    expect(shifted.weeklyGoalId, id);
    move(monday, WeekMovePolicy.unlink);
    final unlinked = service.tasks.require(child.id);
    expect(unlinked.weeklyGoalId, isNull);
    expect(unlinked.scheduledDate, shifted.scheduledDate);
  });

  for (final policy in DeletePolicy.values) {
    test(
      'monthly deletion with ${policy.name} handles only its descendants',
      () {
        final parent = month();
        final child = week(parent: parent);
        final linked = task(parent: child);
        final independent = task();
        final unrelatedGoal = week();
        final unrelated = task(parent: unrelatedGoal);
        service.deleteMonthly(parent, policy);
        expect(service.monthly.find(parent), isNull);
        expect(service.tasks.find(independent.id), independent);
        expect(service.tasks.find(unrelated.id), unrelated);
        if (policy == DeletePolicy.preserve) {
          expect(service.weekly.require(child).monthlyGoalId, isNull);
          expect(service.tasks.require(linked.id), linked);
        } else {
          expect(service.weekly.find(child), isNull);
          expect(service.tasks.find(linked.id), isNull);
        }
      },
    );

    test('weekly deletion with ${policy.name} handles only its tasks', () {
      final parent = month();
      final child = week(parent: parent);
      final linked = task(parent: child);
      final independent = task();
      service.deleteWeekly(child, policy);
      expect(service.monthly.find(parent), isNotNull);
      expect(service.tasks.find(independent.id), independent);
      if (policy == DeletePolicy.preserve) {
        expect(service.tasks.require(linked.id).weeklyGoalId, isNull);
      } else {
        expect(service.tasks.find(linked.id), isNull);
      }
    });
  }

  test('repositories provide initial and updated streams and reject invalid mutations', () async {
    final notifications = <List<PlannerTask>>[];
    final subscription = service.tasks.watchAll().listen(notifications.add);
    addTearDown(subscription.cancel);
    final goal = week();
    final original = task(parent: goal);
    await expectLater(
      service.tasks.create(original),
      throwsA(isA<PlannerException>()),
    );
    await expectLater(
      service.weekly.delete(goal),
      throwsA(isA<PlannerException>()),
    );
    expect(await service.tasks.getById(original.id), original);
    expect(await service.tasks.getBetween(monday, tuesday), [original]);
    final updated = original.copyWith(title: 'Updated');
    await service.tasks.update(updated);
    await service.tasks.delete(original.id);
    expect(notifications, [
      [],
      [original],
      [updated],
      [],
    ]);
  });

  test(
    'calendar and goal metrics update separately from manual goal status',
    () {
      final container = ProviderContainer(
        overrides: [plannerServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);
      final parent = month();
      final child = week(parent: parent);
      final december = (start: tuesday, end: DateTime(2026, 12, 31));
      final acrossMonths = (start: monday, end: sundayOf(monday));
      expect(container.read(monthlyGoalProgressProvider(parent)).percentage, 0);
      final linked = task(parent: child, date: monday, completed: true);
      expect(container.read(weeklyGoalProgressProvider(child)).percentage, 100);
      for (var index = 0; index < 4; index++) {
        task(parent: child, completed: index < 2);
      }
      task(completed: true);
      expect(
        container.read(monthlyGoalProgressProvider(parent)).percentage,
        60,
      );
      expect(container.read(periodProgressProvider(december)).completed, 3);
      expect(container.read(periodProgressProvider(acrossMonths)).completed, 4);
      expect(service.monthly.require(parent).isCompleted, isFalse);
      container.read(taskProvider.notifier).toggle(linked.id);
      expect(
        container.read(monthlyGoalProgressProvider(parent)).percentage,
        40,
      );
      expect(container.read(periodProgressProvider(acrossMonths)).completed, 3);
      expect(container.read(periodProgressProvider(december)).completed, 3);
      service.toggleMonthly(parent);
      expect(
        container.read(monthlyGoalProgressProvider(parent)).percentage,
        40,
      );
      final duplicates = store.snapshot.copyWith(tasks: [linked, linked]);
      expect(monthlyGoalProgress(duplicates, parent).total, 1);
    },
  );

  test(
    'task sorting is deterministic and high-priority filtering excludes others',
    () {
      final overdue = task(
        title: 'A',
        date: monday,
        priority: TaskPriority.low,
        deadline: monday,
      );
      final high = task(
        title: 'B',
        priority: TaskPriority.high,
        completed: true,
      );
      final due = task(title: 'C', deadline: tuesday);
      expect(filterTasks(service.tasks.items, TaskFilter.highPriority), [high]);
      expect(sortTasks(service.tasks.items, TaskSort.priority), [
        high,
        due,
        overdue,
      ]);
      expect(sortTasks(service.tasks.items, TaskSort.scheduled), [
        overdue,
        due,
        high,
      ]);
      expect(sortTasks(service.tasks.items, TaskSort.deadline), [
        overdue,
        due,
        high,
      ]);
      expect(sortTasks(service.tasks.items, TaskSort.completion), [
        overdue,
        due,
        high,
      ]);
    },
  );
}
