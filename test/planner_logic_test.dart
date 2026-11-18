import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_planner/core/utils/date_helpers.dart';
import 'package:task_planner/features/tasks/domain/entities/task.dart';
import 'package:task_planner/features/planning/presentation/planner_provider.dart';
import 'package:task_planner/features/planning/data/in_memory_planner_store.dart';
import 'package:task_planner/features/planning/data/planner_service.dart';
import 'package:task_planner/features/planning/domain/planner_snapshot.dart';
import 'package:task_planner/features/tasks/presentation/providers/task_provider.dart';

void main() {
  test(
    'date helpers handle time, leap years and month and year boundaries',
    () {
      expect(
        sameDay(DateTime(2026, 11, 17, 23), DateTime(2026, 11, 17)),
        isTrue,
      );
      expect(sameDay(DateTime(2026, 11, 18), DateTime(2026, 11, 17)), isFalse);
      expect(daysInMonth(DateTime(2024, 2)), 29);
      expect(daysInMonth(DateTime(2100, 2)), 28);
      expect(shiftMonth(DateTime(2026, 12, 31), 1), DateTime(2027));
      expect(mondayOf(DateTime(2027)), DateTime(2026, 12, 28));
      expect(sundayOf(DateTime(2027)), DateTime(2027, 1, 3));
    },
  );

  test(
    'task CRUD updates filters and progress from a single shared collection',
    () {
      final store = InMemoryPlannerStore(PlannerSnapshot());
      addTearDown(store.dispose);
      final container = ProviderContainer(
        overrides: [
          plannerServiceProvider.overrideWithValue(PlannerService(store)),
        ],
      );
      addTearDown(container.dispose);
      final controller = container.read(taskProvider.notifier);
      final date = DateTime(2040, 2, 29);
      List<PlannerTask> tasksOn(DateTime day) =>
          tasksBetween(container.read(taskProvider), day, day);

      void create(String title) => controller.save(
        title: title,
        description: ' notes ',
        date: DateTime(2040, 2, 29, 12),
        priority: TaskPriority.medium,
        completed: false,
      );
      expect(() => create('   '), throwsArgumentError);
      create(' Draft ');
      create('Review');
      final original = tasksOn(date).first;
      expect(original.title, 'Draft');
      expect(original.description, 'notes');
      expect(original.scheduledDate, date);
      expect(tasksOn(date).map((task) => task.id).toSet(), hasLength(2));

      controller.toggle(original.id);
      expect(
        filterTasks(tasksOn(date), TaskFilter.completed).single.id,
        original.id,
      );
      expect(
        filterTasks(tasksOn(date), TaskFilter.pending).single.title,
        'Review',
      );
      expect(TaskProgress(tasksOn(date)).percentage, 50);
      controller.toggle(original.id);
      expect(TaskProgress(tasksOn(date)).pending, 2);

      final next = shiftDay(date, 1);
      controller.save(
        id: original.id,
        title: 'Updated',
        description: '',
        date: next,
        priority: TaskPriority.high,
        completed: true,
      );
      final edited = tasksOn(next).single;
      expect(edited.id, original.id);
      expect(edited.createdAt, original.createdAt);
      expect(edited.title, 'Updated');
      expect(edited.priority, TaskPriority.high);
      expect(edited.description, isNull);
      expect(TaskProgress(tasksOn(next)).percentage, 100);
      expect(tasksOn(date).single.title, 'Review');
      controller.delete(edited.id);
      expect(tasksOn(next), isEmpty);
      expect(TaskProgress(tasksOn(next)).percentage, 0);
    },
  );
}
