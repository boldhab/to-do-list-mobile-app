import '../../../../core/utils/date_helpers.dart';
import '../../../planning/data/in_memory_entity_repository.dart';
import '../../../planning/domain/planner_snapshot.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class InMemoryTaskRepository extends InMemoryEntityRepository<PlannerTask>
    implements TaskRepository {
  InMemoryTaskRepository(super.store);

  @override
  List<PlannerTask> read(PlannerSnapshot snapshot) => snapshot.tasks;

  @override
  PlannerSnapshot replace(
    PlannerSnapshot snapshot,
    Iterable<PlannerTask> items,
  ) => snapshot.copyWith(tasks: items);

  @override
  String idOf(PlannerTask item) => item.id;

  @override
  Future<List<PlannerTask>> getBetween(DateTime start, DateTime end) async =>
      items
          .where((task) => dateInRange(task.scheduledDate, start, end))
          .toList();
}
