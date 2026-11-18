import '../../../planning/data/in_memory_entity_repository.dart';
import '../../../planning/domain/planner_snapshot.dart';
import '../../domain/entities/monthly_goal.dart';
import '../../domain/repositories/monthly_goal_repository.dart';

class InMemoryMonthlyGoalRepository
    extends InMemoryEntityRepository<MonthlyGoal>
    implements MonthlyGoalRepository {
  InMemoryMonthlyGoalRepository(super.store);

  @override
  List<MonthlyGoal> read(PlannerSnapshot snapshot) => snapshot.monthly;

  @override
  PlannerSnapshot replace(
    PlannerSnapshot snapshot,
    Iterable<MonthlyGoal> items,
  ) => snapshot.copyWith(monthly: items);

  @override
  String idOf(MonthlyGoal item) => item.id;
}
