import '../../recurrence/domain/recurrence_rule.dart';
import '../../tasks/domain/entities/task.dart';
import '../../../core/utils/date_helpers.dart';

enum SearchStatus { all, pending, completed, overdue }

enum TaskLink { all, linked, independent }

enum SearchSort {
  dateAscending,
  dateDescending,
  deadline,
  priority,
  created,
  updated,
  completion,
}

enum SearchPeriod { all, today, week, month, custom }

typedef SearchFilters = ({
  SearchStatus status,
  TaskPriority? priority,
  TaskLink link,
  bool recurring,
  SearchSort sort,
  SearchPeriod period,
  DateRange? custom,
});

const defaultSearchFilters = (
  status: SearchStatus.all,
  priority: null,
  link: TaskLink.all,
  recurring: false,
  sort: SearchSort.dateAscending,
  period: SearchPeriod.all,
  custom: null,
);

final _whitespace = RegExp(r'\s+');

String normalizedSearch(String text) =>
    text.trim().toLowerCase().replaceAll(_whitespace, ' ');

bool isOverdue(PlannerTask task, DateTime now) =>
    !task.isCompleted && task.dueAt?.isBefore(now) == true;

List<PlannerTask> filterAndSortTasks(
  Iterable<PlannerTask> tasks,
  String query,
  SearchFilters filters,
  DateTime now,
  Map<String, String> goalSearchLabels,
) {
  final normalized = normalizedSearch(query);
  final terms = normalized.isEmpty ? const <String>[] : normalized.split(' ');
  final result = tasks.where((task) {
    final matchesStatus = switch (filters.status) {
      SearchStatus.all => true,
      SearchStatus.pending => !task.isCompleted,
      SearchStatus.completed => task.isCompleted,
      SearchStatus.overdue => isOverdue(task, now),
    };
    final matchesLink = switch (filters.link) {
      TaskLink.all => true,
      TaskLink.linked => task.weeklyGoalId != null,
      TaskLink.independent => task.weeklyGoalId == null,
    };
    if (!matchesStatus ||
        !matchesLink ||
        (filters.priority != null && task.priority != filters.priority) ||
        (filters.recurring && parseOccurrence(task.id) == null)) {
      return false;
    }
    if (terms.isEmpty) return true;
    final searchable =
        '${task.title} ${task.description ?? ''} ${goalSearchLabels[task.weeklyGoalId] ?? ''}'
            .toLowerCase();
    return terms.every(searchable.contains);
  }).toList();
  return result..sort((a, b) {
    final order = switch (filters.sort) {
      SearchSort.dateAscending => a.scheduledDate.compareTo(b.scheduledDate),
      SearchSort.dateDescending => b.scheduledDate.compareTo(a.scheduledDate),
      SearchSort.priority => b.priority.index.compareTo(a.priority.index),
      SearchSort.deadline => _deadline(a.dueAt, b.dueAt),
      SearchSort.created => b.createdAt.compareTo(a.createdAt),
      SearchSort.updated => b.updatedAt.compareTo(a.updatedAt),
      SearchSort.completion => (a.isCompleted ? 1 : 0).compareTo(
        b.isCompleted ? 1 : 0,
      ),
    };
    if (order != 0) return order;
    final date = a.scheduledDate.compareTo(b.scheduledDate);
    return date == 0 ? a.id.compareTo(b.id) : date;
  });
}

int _deadline(DateTime? a, DateTime? b) {
  if (a == null) return b == null ? 0 : 1;
  return b == null ? -1 : a.compareTo(b);
}
