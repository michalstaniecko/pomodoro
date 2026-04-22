import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/notification_channels.dart';
import '../domain/session_end_notification_texts.dart';

const String endNotificationActionStartNextId =
    'pomodoro_end_action_start_next';
const String endNotificationActionViewId = 'pomodoro_end_action_view';
const String endNotificationPayload = 'pomodoro_end_open_home';

/// Obsługa notyfikacji końca sesji.
///
/// Android: natychmiastowy `show()` po wykryciu ukończenia sesji (kanał
/// `Pomodoro End`, high importance, akcje CTA).
///
/// iOS: `zonedSchedule()` przy starcie/resume sesji (fallback dla braku Live
/// Activity), `cancel()` przy pause/stop/skip/complete.
class SessionEndNotificationService {
  SessionEndNotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> showEndNotification({
    required SessionEndNotificationTexts texts,
  }) async {
    final AndroidNotificationDetails android = AndroidNotificationDetails(
      NotificationChannels.endChannelId,
      NotificationChannels.endChannelName,
      channelDescription: NotificationChannels.endChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          endNotificationActionStartNextId,
          texts.startNextActionLabel,
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          endNotificationActionViewId,
          texts.viewActionLabel,
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );
    await _plugin.show(
      NotificationChannels.endNotificationId,
      texts.title,
      texts.body,
      NotificationDetails(android: android),
      payload: endNotificationPayload,
    );
  }

  Future<void> scheduleEndNotification({
    required DateTime endAt,
    required SessionEndNotificationTexts texts,
  }) async {
    if (!Platform.isIOS) {
      return;
    }
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(endAt, tz.local);
    // Ochrona przed zaplanowaniem w przeszłości — duplikacja sygnału z
    // AudioVibrationSessionNotifier.
    if (!scheduledAt.isAfter(tz.TZDateTime.now(tz.local))) {
      return;
    }
    const DarwinNotificationDetails ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );
    await _plugin.zonedSchedule(
      NotificationChannels.endNotificationId,
      texts.title,
      texts.body,
      scheduledAt,
      const NotificationDetails(iOS: ios),
      payload: endNotificationPayload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelScheduledEndNotification() async {
    await _plugin.cancel(NotificationChannels.endNotificationId);
  }
}
