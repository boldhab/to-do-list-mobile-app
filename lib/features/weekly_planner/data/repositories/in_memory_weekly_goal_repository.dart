import '../../../planning/data/in_memory_entity_repository.dart';
import '../../../planning/domain/planner_snapshot.dart';
import '../../domain/entities/weekly_goal.dart';
import '../../domain/repositories/weekly_goal_repository.dart';

class InMemoryWeeklyGoalRepository extends InMemoryEntityRepository<WeeklyGoal>
    implements WeeklyGoalRepository {
  InMemoryWeeklyGoalRepository(super.store);

  @override
  List<WeeklyGoal> read(PlannerSnapshot snapshot) => snapshot.weekly;

  @override
  PlannerSnapshot replace(
    PlannerSnapshot snapshot,
    Iterable<WeeklyGoal> items,
  ) => snapshot.copyWith(weekly: items);

  @override
  String idOf(WeeklyGoal item) => item.id;
}
