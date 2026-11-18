import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../planning/presentation/planner_provider.dart';
import '../../../productivity/data/preferences.dart';

final themeProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final name = ref.watch(preferencesProvider.select((value) => value.theme));
    return ThemeMode.values.byName(name);
  }

  Future<void> select(ThemeMode mode) async {
    if (ref.read(usesPlannerFixtureProvider)) {
      state = mode;
    } else {
      await ref
          .read(preferencesRepositoryProvider)
          .update((previous) => previous.copyWith(theme: mode.name));
    }
  }
}
