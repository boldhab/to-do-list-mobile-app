import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/database_exception.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../planning/presentation/planner_feedback.dart';
import '../../../planning/presentation/planner_provider.dart';
import '../../../productivity/data/preferences.dart';
import '../../../productivity/presentation/task_options_form.dart';
import '../../../reminders/domain/reminder_rule.dart';
import '../../../reminders/presentation/reminder_provider.dart';
import '../providers/theme_provider.dart';

final _installedVersion = FutureProvider.autoDispose<String?>((ref) async {
  try {
    return await const MethodChannel('task_planner/app_info')
        .invokeMethod<String>('version');
  } on PlatformException {
    return null;
  } on MissingPluginException {
    return null;
  }
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);
    final settings = ref.watch(preferencesProvider);
    final fixture = ref.watch(usesPlannerFixtureProvider);
    final permission = ref.watch(reminderControllerProvider);
    final notifications = ref.read(reminderControllerProvider.notifier);
    final version = ref.watch(_installedVersion).asData?.value;

    Future<void> save(PreferencesRow Function(PreferencesRow) change) =>
        runPlannerAction(
          context,
          () => databaseOperation(
            'save preferences',
            () => ref.read(preferencesRepositoryProvider).update(change),
          ),
          'Preference saved.',
        );

    return PlannerPage(
      title: 'Settings',
      children: [
        const SectionHeader('Appearance'),
        Card(
          child: RadioGroup<ThemeMode>(
            groupValue: mode,
            onChanged: (value) {
              if (value == null) return;
              runPlannerAction(
                context,
                () => databaseOperation(
                  'save theme',
                  () => ref.read(themeProvider.notifier).select(value),
                ),
                'Theme updated.',
              );
            },
            child: const Column(
              children: [
                RadioListTile(value: ThemeMode.system, title: Text('System')),
                RadioListTile(value: ThemeMode.light, title: Text('Light')),
                RadioListTile(value: ThemeMode.dark, title: Text('Dark')),
              ],
            ),
          ),
        ),
        if (!fixture) ...[
          const SectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Enable task reminders'),
            subtitle: Text(permissionLabel(permission)),
            value: settings.remindersEnabled,
            onChanged: (value) =>
                save((row) => row.copyWith(remindersEnabled: value)),
          ),
          DropdownButtonFormField<int>(
            key: ValueKey(settings.reminderOffset),
            initialValue: settings.reminderOffset,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Default reminder timing',
            ),
            items: [
              for (final minutes in reminderOffsets)
                DropdownMenuItem(
                  value: minutes,
                  child: Text(reminderOffsetLabel(minutes)),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                save((row) => row.copyWith(reminderOffset: value));
              }
            },
          ),
          if (permission == PermissionStatus.denied)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: notifications.requestPermission,
                  child: const Text('Request permission'),
                ),
                OutlinedButton(
                  onPressed: () => runPlannerAction(
                    context,
                    () => databaseOperation(
                      'open notification settings',
                      notifications.openSettings,
                    ),
                    'Opened notification settings.',
                  ),
                  child: const Text('Open system settings'),
                ),
              ],
            ),
          const SectionHeader('Calendar'),
          SwitchListTile(
            title: const Text('Start calendar on Sunday'),
            subtitle: const Text(
              'Weekly goals still run from Monday to Sunday.',
            ),
            value: settings.sundayFirst,
            onChanged: (value) =>
                save((row) => row.copyWith(sundayFirst: value)),
          ),
          DropdownButtonFormField<bool>(
            key: ValueKey(settings.calendarWeek),
            initialValue: settings.calendarWeek,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Default calendar view',
            ),
            items: const [
              DropdownMenuItem(value: false, child: Text('Month')),
              DropdownMenuItem(value: true, child: Text('Week')),
            ],
            onChanged: (value) {
              if (value != null) {
                save((row) => row.copyWith(calendarWeek: value));
              }
            },
          ),
          DropdownButtonFormField<String>(
            key: ValueKey(settings.dateFormat),
            initialValue: settings.dateFormat,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Task date format'),
            items: const [
              DropdownMenuItem(value: 'medium', child: Text('Nov 18, 2026')),
              DropdownMenuItem(value: 'short', child: Text('11/18/2026')),
              DropdownMenuItem(value: 'iso', child: Text('2026-11-18')),
            ],
            onChanged: (value) {
              if (value != null) save((row) => row.copyWith(dateFormat: value));
            },
          ),
        ],
        const SectionHeader('App information'),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(appName),
            subtitle: Text(
              version == null
                  ? 'Your planner and preferences are saved on this device.'
                  : 'Version $version\nYour planner and preferences are saved on this device.',
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy policy'),
            onTap: () => showDialog<void>(
              context: context,
              builder: (context) => const _PrivacyPolicyDialog(),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyPolicyDialog extends StatelessWidget {
  const _PrivacyPolicyDialog();

  @override
  Widget build(BuildContext context) {
    const address = String.fromEnvironment('PLANNER_PRIVACY_URL');
    final uri = Uri.tryParse(address);
    final hasPublicPolicy =
        uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty;
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      scrollable: true,
      title: const Text('Task Planner privacy policy'),
      content: const Text(
        'Your tasks, goals, reminder rules and preferences are stored in private app storage. '
        'Productivity statistics are calculated on this device. The app uses Android notifications '
        'for optional reminders and displays a generic alert without task text. '
        'Android backup and transfer rules exclude planner data. '
        'You can remove individual records in the planner or remove all stored data through Android app settings.',
      ),
      actions: [
        if (hasPublicPolicy)
          TextButton(
            onPressed: () async {
              try {
                await const MethodChannel('task_planner/app_info')
                    .invokeMethod<void>('openPrivacyPolicy', {'url': address});
              } on PlatformException {
                if (context.mounted) {
                  plannerMessage(context, 'Unable to open the privacy policy.');
                }
              } on MissingPluginException {
                if (context.mounted) {
                  plannerMessage(context, 'Unable to open the privacy policy.');
                }
              }
            },
            child: const Text('Open published policy'),
          ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
