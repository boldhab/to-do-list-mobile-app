import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_scaffold.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/daily_planner/presentation/screens/daily_screen.dart';
import '../../features/monthly_planner/presentation/screens/monthly_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/tasks/presentation/screens/task_editor_screen.dart';
import '../../features/weekly_planner/presentation/screens/weekly_screen.dart';
import '../../features/monthly_planner/presentation/screens/monthly_goal_editor_screen.dart';
import '../../features/planning/presentation/goal_detail_screen.dart';
import '../../features/weekly_planner/presentation/screens/weekly_goal_editor_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = buildRouter();
  ref.onDispose(router.dispose);
  return router;
});

GoRouter buildRouter({String? initialLocation}) => GoRouter(
  initialLocation: initialLocation,
  errorBuilder: (context, state) => PlannerPage(
    title: 'Page unavailable',
    children: [
      const Text('This page could not be found.'),
      FilledButton(
        onPressed: () => context.go(RouteNames.home),
        child: const Text('Go home'),
      ),
    ],
  ),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppScaffold(shell: shell),
      branches: [
        _branch(RouteNames.home, const DashboardScreen()),
        _branch(RouteNames.monthly, const MonthlyScreen()),
        _branch(RouteNames.weekly, const WeeklyScreen()),
        _branch(RouteNames.daily, const DailyScreen()),
        _branch(RouteNames.settings, const SettingsScreen()),
      ],
    ),
    GoRoute(
      path: RouteNames.analytics,
      builder: (context, state) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: RouteNames.search,
      builder: (context, state) => SearchScreen(
        overdue: state.uri.queryParameters['status'] == 'overdue',
      ),
    ),
    GoRoute(
      path: RouteNames.newMonthlyGoal,
      builder: (context, state) => MonthlyGoalEditorScreen(
        date: state.extra is DateTime ? state.extra as DateTime : null,
      ),
    ),
    GoRoute(
      path: '/monthly/goals/:goalId',
      builder: (context, state) =>
          GoalDetailScreen(id: state.pathParameters['goalId']!, monthly: true),
    ),
    GoRoute(
      path: '/monthly/goals/:goalId/edit',
      builder: (context, state) =>
          MonthlyGoalEditorScreen(id: state.pathParameters['goalId']),
    ),
    GoRoute(
      path: RouteNames.newWeeklyGoal,
      builder: (context, state) {
        final extra = state.extra;
        return switch (extra) {
          (date: final DateTime date, monthlyGoalId: final String id) =>
            WeeklyGoalEditorScreen(date: date, monthlyGoalId: id),
          final DateTime date => WeeklyGoalEditorScreen(date: date),
          _ => const WeeklyGoalEditorScreen(),
        };
      },
    ),
    GoRoute(
      path: '/weekly/goals/:goalId',
      builder: (context, state) =>
          GoalDetailScreen(id: state.pathParameters['goalId']!, monthly: false),
    ),
    GoRoute(
      path: '/weekly/goals/:goalId/edit',
      builder: (context, state) =>
          WeeklyGoalEditorScreen(id: state.pathParameters['goalId']),
    ),
    GoRoute(
      path: RouteNames.create,
      builder: (context, state) => switch (state.extra) {
        (date: final DateTime date, weeklyGoalId: final String id) =>
          TaskEditorScreen(defaultDate: date, weeklyGoalId: id),
        final DateTime date => TaskEditorScreen(defaultDate: date),
        _ => const TaskEditorScreen(),
      },
    ),
    GoRoute(
      path: '/tasks/:taskId/edit',
      builder: (context, state) => TaskEditorScreen(
        id: state.pathParameters['taskId'],
        reschedule: state.extra == true,
      ),
    ),
  ],
);

StatefulShellBranch _branch(String path, Widget screen) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (context, state) => screen)],
);
