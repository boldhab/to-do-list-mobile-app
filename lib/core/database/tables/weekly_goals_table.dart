import 'package:drift/drift.dart';

import 'monthly_goals_table.dart';

@DataClassName('WeeklyGoalRow')
@TableIndex(name: 'weekly_goals_parent', columns: {#monthlyGoalId})
@TableIndex(name: 'weekly_goals_period', columns: {#weekStart})
class WeeklyGoals extends Table {
  TextColumn get id => text()();
  TextColumn get monthlyGoalId => text().nullable().references(
    MonthlyGoals,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get weekStart => integer()();
  IntColumn get weekEnd => integer()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(id)) > 0)',
    'CHECK (length(trim(title)) BETWEEN 1 AND 100)',
    'CHECK (week_start BETWEEN -719162 AND 2932896 AND week_end BETWEEN -719162 AND 2932896)',
    'CHECK (((week_start + 3) % 7 + 7) % 7 = 0 AND week_end = week_start + 6)',
  ];
}
