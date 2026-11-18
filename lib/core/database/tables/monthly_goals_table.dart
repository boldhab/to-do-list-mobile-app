import 'package:drift/drift.dart';

@DataClassName('MonthlyGoalRow')
@TableIndex(name: 'monthly_goals_period', columns: {#year, #month})
class MonthlyGoals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (length(trim(id)) > 0)',
    'CHECK (length(trim(title)) BETWEEN 1 AND 100)',
    'CHECK (year BETWEEN 1 AND 9999 AND month BETWEEN 1 AND 12)',
  ];
}
