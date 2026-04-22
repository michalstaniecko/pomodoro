import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/permission_handler_coordinator.dart';
import '../domain/notification_permission_coordinator.dart';

final notificationPermissionCoordinatorProvider =
    Provider<NotificationPermissionCoordinator>(
      (ref) => const PermissionHandlerCoordinator(),
    );

/// Flaga „in-app komunikat o brak uprawnień już pokazany w tej sesji appki".
/// Przechowywana w pamięci — reset przy restarcie aplikacji. Używana w
/// `home_screen.dart`, żeby snackbar z CTA „Otwórz ustawienia" pokazać tylko raz
/// dla `permanentlyDenied` (patrz issue #66).
final permissionDeniedMessageShownProvider = StateProvider<bool>(
  (ref) => false,
);
