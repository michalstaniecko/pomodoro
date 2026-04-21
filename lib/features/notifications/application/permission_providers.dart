import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/permission_handler_coordinator.dart';
import '../domain/notification_permission_coordinator.dart';

final notificationPermissionCoordinatorProvider =
    Provider<NotificationPermissionCoordinator>(
      (ref) => const PermissionHandlerCoordinator(),
    );
