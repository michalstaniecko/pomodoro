import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/audio_vibration_session_notifier.dart';
import '../data/session_end_notification_service.dart';
import '../domain/session_notifier.dart';

final sessionNotifierProvider = Provider<SessionNotifier>((ref) {
  final SessionNotifier notifier = AudioVibrationSessionNotifier();
  ref.onDispose(() {
    unawaited(notifier.dispose());
  });
  return notifier;
});

/// W `main()` kontener jest tworzony z override wskazującym na instancję
/// zainicjalizowaną przez `LocalNotificationsInitializer` (kanały + callbacki
/// tap). Fallback tworzy nową instancję — tylko dla testów.
final flutterLocalNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
      return FlutterLocalNotificationsPlugin();
    });

final sessionEndNotificationServiceProvider =
    Provider<SessionEndNotificationService>((ref) {
      return SessionEndNotificationService(
        ref.watch(flutterLocalNotificationsPluginProvider),
      );
    });
