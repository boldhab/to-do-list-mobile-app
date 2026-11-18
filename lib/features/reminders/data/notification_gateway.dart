import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

abstract interface class NotificationGateway {
  Future<void> initialize(void Function(String) onTap);
  Future<String> refreshTimezone();
  Future<bool> allowed();
  Future<bool> requestPermission();
  Future<void> openSettings();
  Future<Map<int, String>> pending();
  Future<void> schedule(int id, DateTime utc, String taskId);
  Future<void> cancel(int id);
}

const reminderPayloadPrefix = 'task-planner:';

String? decodeReminderPayload(String? payload) {
  if (payload == null || !payload.startsWith(reminderPayloadPrefix)) {
    return null;
  }
  final id = payload.substring(reminderPayloadPrefix.length);
  return RegExp(r'^[-_a-zA-Z0-9]{1,128}(~-?[0-9]{1,8})?$').hasMatch(id)
      ? id
      : null;
}

const _channel = AndroidNotificationChannel(
  'planner_reminders',
  'Task reminders',
  description: 'Reminders for deadlines and recurring tasks',
);

class LocalNotificationGateway implements NotificationGateway {
  final _plugin = FlutterLocalNotificationsPlugin();
  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<void> initialize(void Function(String) onTap) async {
    if (!_supported) return;
    void route(String? payload) {
      final id = decodeReminderPayload(payload);
      if (id != null) onTap(id);
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_planner'),
      ),
      onDidReceiveNotificationResponse: (response) => route(response.payload),
    );
    tzdata.initializeTimeZones();
    await _android?.createNotificationChannel(_channel);
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      route(launch?.notificationResponse?.payload);
    }
  }

  @override
  Future<String> refreshTimezone() async {
    if (!_supported) return 'UTC';
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
      return info.identifier;
    } catch (_) {
      // UTC still schedules the supplied instant correctly when the device
      // reports a zone identifier missing from the bundled database.
      tz.setLocalLocation(tz.UTC);
      return 'UTC';
    }
  }

  @override
  Future<bool> allowed() async =>
      _supported && (await _android?.areNotificationsEnabled() ?? false);

  @override
  Future<bool> requestPermission() async =>
      _supported && (await _android?.requestNotificationsPermission() ?? false);

  @override
  Future<void> openSettings() async {
    if (_supported) {
      await const MethodChannel('task_planner/notifications')
          .invokeMethod<void>('openSettings');
    }
  }

  @override
  Future<Map<int, String>> pending() async {
    if (!_supported) return const {};
    return {
      for (final request in await _plugin.pendingNotificationRequests())
        if (request.payload?.startsWith(reminderPayloadPrefix) == true)
          request.id: request.payload!,
    };
  }

  @override
  Future<void> schedule(int id, DateTime utc, String taskId) =>
      _plugin.zonedSchedule(
        id: id,
        title: 'Task Planner',
        body: 'You have a task reminder.',
        scheduledDate: tz.TZDateTime.from(utc, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'planner_reminders',
            'Task reminders',
            channelDescription: 'Reminders for deadlines and recurring tasks',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: '$reminderPayloadPrefix$taskId',
      );

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);
}
