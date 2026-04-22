/// Identyfikatory i nazwy kanałów notyfikacji systemowych.
///
/// Wydzielone do warstwy domenowej, bo te stałe będą referencjonowane przez
/// późniejsze issues (foreground service, live activity, scheduled reminders)
/// niezależnie od konkretnej implementacji pluginu.
class NotificationChannels {
  const NotificationChannels._();

  /// Kanał dla trwającej sesji (ongoing, low-importance — reguła UX:
  /// brak inwazyjnych notyfikacji w trakcie pracy).
  static const String sessionChannelId = 'pomodoro_session';
  static const String sessionChannelName = 'Pomodoro Session';
  static const String sessionChannelDescription =
      'Trwająca sesja Pomodoro z licznikiem.';

  /// Kanał dla zakończenia sesji (high-importance z dźwiękiem — sygnał
  /// powinien zostać zauważony nawet przy wyciszonym telefonie).
  static const String endChannelId = 'pomodoro_end';
  static const String endChannelName = 'Pomodoro End';
  static const String endChannelDescription =
      'Powiadomienie o zakończeniu sesji lub przerwy.';

  /// ID zarezerwowane dla notyfikacji końca sesji (Android + iOS scheduled).
  /// Inne niż foreground service notification ID (1001).
  static const int endNotificationId = 2001;
}
