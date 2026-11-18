import '../../../core/utils/date_helpers.dart';
import '../../search/domain/task_search.dart';
import '../../tasks/domain/entities/task.dart';

typedef PerformanceBucket = ({DateTime day, int planned, int completed});

List<PerformanceBucket> performanceBuckets(
  List<PlannerTask> tasks,
  DateTime first,
  DateTime last, {
  int stride = 1,
}) {
  final days = <DateTime, (int, int)>{};
  for (final task in tasks) {
    final day = dateOnly(task.scheduledDate);
    final (planned, completed) = days[day] ?? (0, 0);
    days[day] = (planned + 1, completed + (task.isCompleted ? 1 : 0));
  }
  return [
    for (var date = first; !date.isAfter(last); date = shiftDay(date, stride))
      _bucket(date, last, stride, days),
  ];
}

PerformanceBucket _bucket(
  DateTime first,
  DateTime last,
  int stride,
  Map<DateTime, (int, int)> days,
) {
  var planned = 0;
  var completed = 0;
  for (var offset = 0; offset < stride; offset++) {
    final day = shiftDay(first, offset);
    if (day.isAfter(last)) break;
    final (total, done) = days[day] ?? (0, 0);
    planned += total;
    completed += done;
  }
  return (day: first, planned: planned, completed: completed);
}

int overdueCount(List<PlannerTask> tasks, DateTime now) =>
    tasks.where((task) => isOverdue(task, now)).length;

int completionStreak(
  List<PlannerTask> tasks,
  DateTime today, {
  int lookback = 90,
}) {
  final first = shiftDay(today, 1 - lookback);
  final days = performanceBuckets(tasks, first, today).reversed;
  final previous =
      days.first.planned == 0 || days.first.completed < days.first.planned
      ? days.skip(1)
      : days;
  return previous
      .takeWhile((day) => day.planned > 0 && day.planned == day.completed)
      .length;
}

int completionRate(int completed, int total) =>
    total == 0 ? 0 : (100 * completed / total).round();
