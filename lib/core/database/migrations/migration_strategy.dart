import 'package:drift/drift.dart';

import '../app_database.dart';

MigrationStrategy plannerMigration(AppDatabase database) => MigrationStrategy(
  onCreate: (migrator) => database.transaction(migrator.createAll),
  onUpgrade: (migrator, from, to) async {
    if (from == 1 && to == 2) {
      await database.transaction(() async {
        await migrator.createTable(database.recurrenceRules);
        await migrator.createTable(database.occurrenceStates);
        await migrator.createTable(database.reminderRules);
        await migrator.createTable(database.reminderDeliveries);
        await migrator.createTable(database.applicationSettings);
        await migrator.createIndex(database.recurrencePeriod);
        await migrator.createIndex(database.occurrenceSchedule);
        await migrator.createIndex(database.remindersTask);
      });
      return;
    }
    throw UnsupportedError(
      'Unsupported planner schema transition: $from to $to',
    );
  },
  beforeOpen: (details) async {
    await database.customStatement('PRAGMA foreign_keys = ON');
  },
);
