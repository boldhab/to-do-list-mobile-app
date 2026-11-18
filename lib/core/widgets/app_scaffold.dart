import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_spacing.dart';
import 'custom_app_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (index) => shell.goBranch(index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.space_dashboard_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Month',
        ),
        NavigationDestination(
          icon: Icon(Icons.view_week_outlined),
          label: 'Week',
        ),
        NavigationDestination(icon: Icon(Icons.today_outlined), label: 'Today'),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    ),
  );
}

class PlannerPage extends StatelessWidget {
  const PlannerPage({
    super.key,
    required this.title,
    required this.children,
    this.taskItemCount = 0,
    this.taskItemBuilder,
  }) : assert(taskItemCount == 0 || taskItemBuilder != null);

  final String title;
  final List<Widget> children;
  final int taskItemCount;
  final IndexedWidgetBuilder? taskItemBuilder;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(title),
    body: SafeArea(
      top: false,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        itemBuilder: (context, index) => Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SizedBox(
              width: double.infinity,
              child: index < children.length
                  ? children[index]
                  : taskItemBuilder!(context, index - children.length),
            ),
          ),
        ),
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.lg),
        itemCount: children.length + taskItemCount,
      ),
    ),
  );
}
