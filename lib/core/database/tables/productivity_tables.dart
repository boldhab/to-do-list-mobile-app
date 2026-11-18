import 'package:drift/drift.dart';

import 'tasks_table.dart';

@DataClassName('RecurrenceRow')
@TableIndex(name: 'recurrence_period', columns: {#startDay, #endDay})
class RecurrenceRules extends Table {
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  TextColumn get frequency => text()();
  IntColumn get interval => integer()();
  IntColumn get weekdays => integer()();
  IntColumn get monthDay => integer()();
  IntColumn get startDay => integer()();
  IntColumn get endDay => integer().nullable()();
  IntColumn get occurrenceCount => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {taskId};

  @override
  List<String> get customConstraints => [
    "CHECK (frequency IN ('daily', 'weekly', 'monthly'))",
    'CHECK (interval >= 1 AND weekdays BETWEEN 1 AND 127 AND month_day BETWEEN 1 AND 31)',
    'CHECK (occurrence_count IS NULL OR occurrence_count >= 1)',
  ];
}

@DataClassName('OccurrenceRow')
@TableIndex(name: 'occurrence_schedule', columns: {#scheduledDay})
class OccurrenceStates extends Table {
  TextColumn get taskId => text().references(
    RecurrenceRules,
    #taskId,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get occurrenceDay => integer()();
  IntColumn get scheduledDay => integer()();
  TextColumn get overrideData => text().nullable()();
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {taskId, occurrenceDay};
}

@DataClassName('ReminderRow')
@TableIndex(name: 'reminders_task', columns: {#taskId})
class ReminderRules extends Table {
  TextColumn get id => text()();
  TextColumn get taskId =>
      text().references(Tasks, #id, onDelete: KeyAction.cascade)();
  IntColumn get occurrenceDay => integer().nullable()();
  IntColumn get minutesBefore => integer().nullable()();
  DateTimeColumn get absoluteTime => dateTime().nullable()();
  BoolColumn get enabled => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'CHECK (enabled = 0 OR ((minutes_before IS NULL) != (absolute_time IS NULL)))',
    'CHECK (minutes_before IS NULL OR minutes_before >= 0)',
  ];
}

@DataClassName('DeliveryRow')
class ReminderDeliveries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get occurrenceKey => text().unique()();
  TextColumn get fingerprint => text()();
  TextColumn get state => text()();
  DateTimeColumn get fireAt => dateTime()();
  TextColumn get taskId => text()();
}

@DataClassName('PreferencesRow')
class ApplicationSettings extends Table {
  IntColumn get id => integer()();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  BoolColumn get remindersEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get reminderOffset => integer().withDefault(const Constant(15))();
  BoolColumn get sundayFirst => boolean().withDefault(const Constant(false))();
  BoolColumn get calendarWeek => boolean().withDefault(const Constant(false))();
  TextColumn get dateFormat => text().withDefault(const Constant('medium'))();

  @override
  Set<Column> get primaryKey => {id};
}
