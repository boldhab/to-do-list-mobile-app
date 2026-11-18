class MonthlyGoal {
  const MonthlyGoal({
    required this.id,
    required this.title,
    this.description,
    required this.year,
    required this.month,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final int year;
  final int month;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  MonthlyGoal copyWith({
    String? title,
    String? description,
    bool clearDescription = false,
    int? year,
    int? month,
    bool? isCompleted,
    DateTime? updatedAt,
  }) => MonthlyGoal(
    id: id,
    title: title ?? this.title,
    description: clearDescription ? null : description ?? this.description,
    year: year ?? this.year,
    month: month ?? this.month,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Object get _value =>
      (id, title, description, year, month, isCompleted, createdAt, updatedAt);

  @override
  bool operator ==(Object other) =>
      other is MonthlyGoal && _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}
