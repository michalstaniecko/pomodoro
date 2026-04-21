import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../domain/notification_channels.dart';

/// Inicjalizuje `FlutterLocalNotificationsPlugin`: ustawia settings natywne,
/// tworzy kanały Android. Runtime permissions (POST_NOTIFICATIONS / iOS alert+
/// badge+sound) obsługuje `NotificationPermissionCoordinator` wołany przed
/// pierwszym startem timera — nie duplikujemy promptu z poziomu pluginu.
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

    // request*Permission = false — prompt obsługuje `permission_handler`
    // przed pierwszym startem timera, nie w `main()`.
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

    // Callbacki tap-response są potrzebne, żeby plugin wystawił PendingIntent
    // na MainActivity — tap na korpus ongoing notyfikacji wybudza app.
    await plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onForegroundTap,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundTap,
    );

    await _createAndroidChannels(plugin);

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
}

@pragma('vm:entry-point')
void _onForegroundTap(NotificationResponse response) {
  // Plugin samoistnie otwiera MainActivity przez swój PendingIntent.
  // Router ma initialLocation '/' (timer) → user trafia na właściwy ekran.
  // Action press (pause/resume/stop) jest obsłużony w AndroidForegroundService.
}

@pragma('vm:entry-point')
void _onBackgroundTap(NotificationResponse response) {
  // No-op — handler istnieje, żeby plugin wystawił background PendingIntent
  // dla scenariusza z zabitą aplikacją.
}
