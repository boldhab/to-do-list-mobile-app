import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../planning/presentation/planner_provider.dart';

const defaultPreferences = PreferencesRow(
  id: 1,
  theme: 'system',
  remindersEnabled: true,
  reminderOffset: 15,
  sundayFirst: false,
  calendarWeek: false,
  dateFormat: 'medium',
);

final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => PreferencesRepository(ref.watch(appDatabaseProvider)),
);

final _storedPreferencesProvider = StreamProvider<PreferencesRow>(
  (ref) => ref.watch(preferencesRepositoryProvider).watch(),
);

final preferencesProvider = Provider<PreferencesRow>((ref) {
  if (ref.watch(usesPlannerFixtureProvider)) return defaultPreferences;
  final planner = ref.watch(plannerLoadProvider);
  if (planner.asData == null) return defaultPreferences;
  return ref.watch(_storedPreferencesProvider).asData?.value ??
      defaultPreferences;
});

class PreferencesRepository {
  PreferencesRepository(this.db);
  final AppDatabase db;

  Future<PreferencesRow> get() async =>
      await (db.select(
        db.applicationSettings,
      )..where((row) => row.id.equals(1))).getSingleOrNull() ??
      defaultPreferences;

  Stream<PreferencesRow> watch() =>
      (db.select(db.applicationSettings)..where((row) => row.id.equals(1)))
          .watchSingleOrNull()
          .map((row) => row ?? defaultPreferences)
          .distinct();

  Future<void> update(PreferencesRow Function(PreferencesRow) change) =>
      db.transaction(() async {
        await db
            .into(db.applicationSettings)
            .insertOnConflictUpdate(change(await get()));
      });
}

String plannerDate(DateTime date, PreferencesRow preferences) =>
    switch (preferences.dateFormat) {
      'iso' => DateFormat('yyyy-MM-dd').format(date),
      'short' => DateFormat.yMd().format(date),
      _ => DateFormat.yMMMd().format(date),
    };
