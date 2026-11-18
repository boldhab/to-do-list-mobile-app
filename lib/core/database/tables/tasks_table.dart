import 'package:drift/drift.dart';

import 'weekly_goals_table.dart';

@DataClassName('TaskRow')
@TableIndex(name: 'tasks_parent', columns: {#weeklyGoalId})
@TableIndex(name: 'tasks_scheduled', columns: {#scheduledDate})
@TableIndex(name: 'tasks_deadline', columns: {#dueAt})
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get weeklyGoalId => text().nullable().references(
    WeeklyGoals,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get scheduledDate => integer()();
  DateTimeColumn get dueAt => dateTime().nullable()();
  TextColumn get priority => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(id)) > 0)',
    'CHECK (length(trim(title)) BETWEEN 1 AND 100)',
    'CHECK (scheduled_date BETWEEN -719162 AND 2932896)',
    "CHECK (priority IN ('low', 'medium', 'high'))",
    'CHECK ((is_completed = 1 AND completed_at IS NOT NULL) OR (is_completed = 0 AND completed_at IS NULL))',
  ];
}
