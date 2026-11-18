import '../../../../core/data/entity_repository.dart';
import '../entities/task.dart';

abstract interface class TaskRepository
    implements EntityRepository<PlannerTask> {
  Future<List<PlannerTask>> getBetween(DateTime start, DateTime end);
}
