enum TaskPriority { low, medium, high }

class PlannerTask {
  const PlannerTask({
    required this.id,
    required this.title,
    this.description,
    this.weeklyGoalId,
    this.dueAt,
    this.completedAt,
    required this.scheduledDate,
    required this.priority,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final String? weeklyGoalId;
  final DateTime? dueAt;
  final DateTime? completedAt;
  final DateTime scheduledDate;
  final TaskPriority priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlannerTask copyWith({
    String? title,
    String? description,
    String? weeklyGoalId,
    bool clearWeeklyGoal = false,
    DateTime? dueAt,
    bool clearDeadline = false,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    bool clearDescription = false,
    DateTime? scheduledDate,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? updatedAt,
  }) => PlannerTask(
    id: id,
    title: title ?? this.title,
    description: clearDescription ? null : description ?? this.description,
    weeklyGoalId: clearWeeklyGoal ? null : weeklyGoalId ?? this.weeklyGoalId,
    dueAt: clearDeadline ? null : dueAt ?? this.dueAt,
    completedAt: clearCompletedAt || isCompleted == false
        ? null
        : completedAt ?? this.completedAt,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    priority: priority ?? this.priority,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Object get _value => (
    id,
    title,
    description,
    weeklyGoalId,
    scheduledDate,
    dueAt,
    priority,
    isCompleted,
    completedAt,
    createdAt,
    updatedAt,
  );

  @override
  bool operator ==(Object other) =>
      other is PlannerTask && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
