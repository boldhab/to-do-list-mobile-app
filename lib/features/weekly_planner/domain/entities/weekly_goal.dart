class WeeklyGoal {
  const WeeklyGoal({
    required this.id,
    required this.title,
    this.description,
    this.monthlyGoalId,
    required this.weekStart,
    required this.weekEnd,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final String? monthlyGoalId;
  final DateTime weekStart;
  final DateTime weekEnd;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  WeeklyGoal copyWith({
    String? title,
    String? description,
    bool clearDescription = false,
    String? monthlyGoalId,
    bool clearMonthlyGoalId = false,
    DateTime? weekStart,
    DateTime? weekEnd,
    bool? isCompleted,
    DateTime? updatedAt,
  }) => WeeklyGoal(
    id: id,
    title: title ?? this.title,
    description: clearDescription ? null : description ?? this.description,
    monthlyGoalId: clearMonthlyGoalId
        ? null
        : monthlyGoalId ?? this.monthlyGoalId,
    weekStart: weekStart ?? this.weekStart,
    weekEnd: weekEnd ?? this.weekEnd,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Object get _value => (
    id,
    title,
    description,
    monthlyGoalId,
    weekStart,
    weekEnd,
    isCompleted,
    createdAt,
    updatedAt,
  );

  @override
  bool operator ==(Object other) =>
      other is WeeklyGoal && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
