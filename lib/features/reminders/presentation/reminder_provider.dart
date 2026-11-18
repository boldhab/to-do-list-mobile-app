import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_router.dart';
import '../../../app/router/route_names.dart';
import '../../planning/presentation/planner_provider.dart';
import '../../productivity/data/productivity_store.dart';
import '../data/notification_gateway.dart';
import '../data/reminder_scheduler.dart';

enum PermissionStatus { checking, allowed, denied, unavailable }

final notificationGatewayProvider = Provider<NotificationGateway>(
  (ref) => LocalNotificationGateway(),
);

final reminderControllerProvider =
    NotifierProvider<ReminderController, PermissionStatus>(
      ReminderController.new,
    );

class ReminderController extends Notifier<PermissionStatus> {
  bool _running = false;
  bool _dirty = false;
  Future<void>? _initialized;
  late void Function(String) _onTap;
  late NotificationGateway _gateway;
  late ReminderScheduler _scheduler;
  bool _disposed = false;

  @override
  PermissionStatus build() {
    if (ref.watch(usesPlannerFixtureProvider)) {
      return PermissionStatus.unavailable;
    }
    _disposed = false;
    final store = ref.watch(productivityStoreProvider);
    _gateway = ref.watch(notificationGatewayProvider);
    _scheduler = ReminderScheduler(store, _gateway);
    final router = ref.read(routerProvider);
    _initialized = null;
    _onTap = (id) {
      if (!_disposed) unawaited(router.push(RouteNames.edit(id)));
    };
    final db = store.db;
    final subscription = store
        .watchChanges({
          ...store.taskTables,
          db.reminderRules,
          db.applicationSettings,
        }, () async => null)
        .listen(
          (_) => refresh(),
          onError: (Object error) {
            if (!_disposed) state = PermissionStatus.unavailable;
          },
        );
    ref.onDispose(() {
      _disposed = true;
      unawaited(subscription.cancel());
    });
    unawaited(refresh());
    return PermissionStatus.checking;
  }

  Future<void> _ensureInitialized() async {
    try {
      await (_initialized ??= _gateway.initialize(_onTap));
    } catch (_) {
      _initialized = null;
      rethrow;
    }
  }

  Future<void> refresh() async {
    _dirty = true;
    if (_running) return;
    _running = true;
    try {
      while (_dirty && !_disposed) {
        _dirty = false;
        try {
          await _ensureInitialized();
          final allowed = await _scheduler.reconcile();
          if (!_disposed) {
            state = allowed
                ? PermissionStatus.allowed
                : PermissionStatus.denied;
          }
        } catch (_) {
          if (!_disposed) state = PermissionStatus.unavailable;
        }
      }
    } finally {
      _running = false;
    }
  }

  Future<void> requestPermission() async {
    try {
      await _ensureInitialized();
      await _gateway.requestPermission();
      await refresh();
    } catch (_) {
      if (!_disposed) state = PermissionStatus.unavailable;
    }
  }

  Future<void> openSettings() => _gateway.openSettings();
}

class ReminderLifecycle extends ConsumerStatefulWidget {
  const ReminderLifecycle({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<ReminderLifecycle> createState() => _ReminderLifecycleState();
}

class _ReminderLifecycleState extends ConsumerState<ReminderLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        !ref.read(usesPlannerFixtureProvider)) {
      unawaited(ref.read(reminderControllerProvider.notifier).refresh());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(reminderControllerProvider);
    return widget.child;
  }
}
