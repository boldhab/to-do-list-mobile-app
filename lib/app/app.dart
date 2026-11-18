import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../features/planning/presentation/planner_provider.dart';
import '../features/reminders/presentation/reminder_provider.dart';
import '../features/settings/presentation/providers/theme_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PlannerApp extends ConsumerWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: appName,
    debugShowCheckedModeBanner: false,
    theme: plannerTheme(Brightness.light),
    darkTheme: plannerTheme(Brightness.dark),
    themeMode: ref.watch(themeProvider),
    routerConfig: ref.watch(routerProvider),
    builder: (context, child) => Consumer(
      builder: (context, ref, _) {
        final status = ref.watch(
          plannerLoadProvider.select(
            (state) => (loading: state.isLoading, failed: state.hasError),
          ),
        );
        if (status.failed) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Unable to load your planner. Your saved data has been kept.',
                        textAlign: TextAlign.center,
                      ),
                      FilledButton(
                        onPressed: () => retryPlannerLoad(ref),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (status.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Loading planner',
              ),
            ),
          );
        }
        return ReminderLifecycle(child: child!);
      },
    ),
  );
}
