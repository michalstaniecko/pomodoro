import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pomodoro/features/notifications/data/permission_handler_coordinator.dart';
import 'package:pomodoro/features/notifications/domain/notification_permission_coordinator.dart';

class _FakeBackend implements PermissionBackend {
  _FakeBackend({required this.initial, required this.afterRequest});

  PermissionStatus initial;
  PermissionStatus afterRequest;
  int requestCalls = 0;
  int openSettingsCalls = 0;

  @override
  Future<PermissionStatus> status() async => initial;

  @override
  Future<PermissionStatus> request() async {
    requestCalls++;
    return afterRequest;
  }

  @override
  Future<bool> openSettings() async {
    openSettingsCalls++;
    return true;
  }
}

void main() {
  group('PermissionHandlerCoordinator.ensure', () {
    test('zwraca granted bez pytania gdy już przyznane', () async {
      final backend = _FakeBackend(
        initial: PermissionStatus.granted,
        afterRequest: PermissionStatus.denied,
      );
      final coordinator = PermissionHandlerCoordinator(backend: backend);

      final result = await coordinator.ensure();

      expect(result, NotificationPermissionStatus.granted);
      expect(backend.requestCalls, 0);
    });

    test('pyta gdy denied i mapuje wynik', () async {
      final backend = _FakeBackend(
        initial: PermissionStatus.denied,
        afterRequest: PermissionStatus.granted,
      );
      final coordinator = PermissionHandlerCoordinator(backend: backend);

      final result = await coordinator.ensure();

      expect(result, NotificationPermissionStatus.granted);
      expect(backend.requestCalls, 1);
    });

    test('permanentlyDenied nie wywołuje request', () async {
      final backend = _FakeBackend(
        initial: PermissionStatus.permanentlyDenied,
        afterRequest: PermissionStatus.granted,
      );
      final coordinator = PermissionHandlerCoordinator(backend: backend);

      final result = await coordinator.ensure();

      expect(result, NotificationPermissionStatus.permanentlyDenied);
      expect(backend.requestCalls, 0);
    });

    test('denied po prompt zostaje denied', () async {
      final backend = _FakeBackend(
        initial: PermissionStatus.denied,
        afterRequest: PermissionStatus.denied,
      );
      final coordinator = PermissionHandlerCoordinator(backend: backend);

      final result = await coordinator.ensure();

      expect(result, NotificationPermissionStatus.denied);
    });
  });
}
