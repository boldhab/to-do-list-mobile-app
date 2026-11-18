import '../../features/tasks/domain/entities/task.dart';
import 'date_helpers.dart';

List<PlannerTask> tasksBetween(
  List<PlannerTask> tasks,
  DateTime start,
  DateTime end,
) {
  final firstDay = dateOnly(start);
  final afterLastDay = shiftDay(end, 1);
  return tasks.where((task) {
    final date = dateOnly(task.scheduledDate);
    return !date.isBefore(firstDay) && date.isBefore(afterLastDay);
  }).toList();
}

class TaskProgress {
  TaskProgress(List<PlannerTask> tasks)
    : total = tasks.length,
      completed = tasks.where((task) => task.isCompleted).length;

  final int total;
  final int completed;
  int get pending => total - completed;
  double get ratio => total == 0 ? 0 : completed / total;
  int get percentage => (ratio * 100).round();

  @override
  bool operator ==(Object other) =>
      other is TaskProgress &&
      other.total == total &&
      other.completed == completed;

  @override
  int get hashCode => Object.hash(total, completed);
}
