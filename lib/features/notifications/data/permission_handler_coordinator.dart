import 'package:permission_handler/permission_handler.dart';

import '../domain/notification_permission_coordinator.dart';

/// Cienki adapter nad `permission_handler`. Wydzielony interfejs `PermissionBackend`
/// pozwala testować logikę mapowania statusów bez platform channels.
abstract class PermissionBackend {
  Future<PermissionStatus> status();

  Future<PermissionStatus> request();

  Future<bool> openSettings();
}

class _DefaultPermissionBackend implements PermissionBackend {
  const _DefaultPermissionBackend();

  @override
  Future<PermissionStatus> status() => Permission.notification.status;

  @override
  Future<PermissionStatus> request() => Permission.notification.request();

  @override
  Future<bool> openSettings() => openAppSettings();
}

class PermissionHandlerCoordinator
    implements NotificationPermissionCoordinator {
  const PermissionHandlerCoordinator({PermissionBackend? backend})
    : _backend = backend ?? const _DefaultPermissionBackend();

  final PermissionBackend _backend;

  @override
  Future<NotificationPermissionStatus> status() async {
    final PermissionStatus s = await _backend.status();
    return _map(s);
  }

  @override
  Future<NotificationPermissionStatus> ensure() async {
    final PermissionStatus current = await _backend.status();
    if (current.isGranted) {
      return NotificationPermissionStatus.granted;
    }
    if (current.isPermanentlyDenied) {
      return NotificationPermissionStatus.permanentlyDenied;
    }
    final PermissionStatus requested = await _backend.request();
    return _map(requested);
  }

  @override
  Future<bool> openSettings() => _backend.openSettings();

  NotificationPermissionStatus _map(PermissionStatus s) {
    if (s.isGranted || s.isLimited || s.isProvisional) {
      return NotificationPermissionStatus.granted;
    }
    if (s.isPermanentlyDenied) {
      return NotificationPermissionStatus.permanentlyDenied;
    }
    return NotificationPermissionStatus.denied;
  }
}
