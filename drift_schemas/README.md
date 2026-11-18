# Planner SQLite migrations

Version 1 is the first persistent schema. Earlier releases kept records in memory, so there is no older database to import. The app opens an empty database in its private documents directory on first launch.

Version 2 adds recurrence rules, per-occurrence state, reminder settings and delivery state, and persistent preferences. The v1-to-v2 migration creates these tables and indexes in one transaction and retains existing planner records.

## Adding a schema version

1. Keep the existing versioned schema JSON. Update the table definitions and increment `AppDatabase.schemaVersion`.
2. Run `dart run build_runner build` and `dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas`.
3. Use Drift's schema migration tooling (`dart run drift_dev schema steps --help`) to generate adjacent-version steps. Add the supported transitions to `migration_strategy.dart` and apply them inside a transaction.
4. Test a populated old schema with Drift's schema verifier and confirm that IDs, parent links, dates, and completion states survive. Run `PRAGMA foreign_key_check` after any migration that rebuilds tables.
5. Keep unsupported transitions rejected. Retain generated code and the new snapshot alongside the existing history.

Calendar dates use integer day coordinates that preserve their year, month, and day. Deadlines and audit timestamps use UTC ISO text and are converted to local time for display.
