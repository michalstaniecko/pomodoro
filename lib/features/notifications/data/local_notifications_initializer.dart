import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../domain/notification_channels.dart';

/// Inicjalizuje `FlutterLocalNotificationsPlugin`: ustawia settings natywne,
/// tworzy kanały Android i prosi o uprawnienia runtime (iOS + Android 13+).
///
/// Wywoływane raz z `main()` przed `runApp`. Zwraca gotowy do użycia plugin,
/// który kolejne issues (foreground service, scheduling) wstrzykną przez
/// Riverpod `Provider<FlutterLocalNotificationsPlugin>`.
class LocalNotificationsInitializer {
  const LocalNotificationsInitializer();

  Future<FlutterLocalNotificationsPlugin> initialize() async {
    final FlutterLocalNotificationsPlugin plugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // requestAlertPermission/Badge/Sound = false — uprawnienia prosimy jawnie
    // poniżej, żeby móc sterować momentem promptu w późniejszych issues.
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await plugin.initialize(settings);

    await _createAndroidChannels(plugin);
    await _requestPermissions(plugin);

    return plugin;
  }

  Future<void> _createAndroidChannels(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    final AndroidFlutterLocalNotificationsPlugin? android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) {
      return;
    }

    // Ongoing session: low importance — nie wybija użytkownika z flow.
    const AndroidNotificationChannel sessionChannel =
        AndroidNotificationChannel(
          NotificationChannels.sessionChannelId,
          NotificationChannels.sessionChannelName,
          description: NotificationChannels.sessionChannelDescription,
          importance: Importance.low,
          playSound: false,
          enableVibration: false,
          showBadge: false,
        );

    // Session end: high importance + dźwięk — sygnał końca pracy/przerwy.
    const AndroidNotificationChannel endChannel = AndroidNotificationChannel(
      NotificationChannels.endChannelId,
      NotificationChannels.endChannelName,
      description: NotificationChannels.endChannelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await android.createNotificationChannel(sessionChannel);
    await android.createNotificationChannel(endChannel);
  }

  Future<void> _requestPermissions(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    if (Platform.isIOS) {
      await plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      await plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }
}
