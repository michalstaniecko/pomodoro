import 'package:shared_preferences/shared_preferences.dart';

import '../../timer/application/timer_settings.dart';
import '../domain/settings_repository.dart';

class SharedPreferencesSettingsRepository implements SettingsRepository {
  SharedPreferencesSettingsRepository();

  static const String keyWorkMinutes = 'pomodoro.settings.workMinutes';
  static const String keyShortBreakMinutes =
      'pomodoro.settings.shortBreakMinutes';
  static const String keyLongBreakMinutes =
      'pomodoro.settings.longBreakMinutes';
  static const String keySessionsBeforeLongBreak =
      'pomodoro.settings.sessionsBeforeLongBreak';
  static const String keyAutoStartBreaks = 'pomodoro.settings.autoStartBreaks';
  static const String keyAutoStartNextWork =
      'pomodoro.settings.autoStartNextWork';
  static const String keySoundEnabled = 'pomodoro.settings.soundEnabled';
  static const String keyVibrationEnabled =
      'pomodoro.settings.vibrationEnabled';

  @override
  Future<TimerSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    const defaults = TimerSettings();

    final work = _clampOrDefault(
      prefs.getInt(keyWorkMinutes),
      TimerSettings.workMinMinutes,
      TimerSettings.workMaxMinutes,
      defaults.workDuration.inMinutes,
    );
    final shortBreak = _clampOrDefault(
      prefs.getInt(keyShortBreakMinutes),
      TimerSettings.shortBreakMinMinutes,
      TimerSettings.shortBreakMaxMinutes,
      defaults.shortBreakDuration.inMinutes,
    );
    final longBreak = _clampOrDefault(
      prefs.getInt(keyLongBreakMinutes),
      TimerSettings.longBreakMinMinutes,
      TimerSettings.longBreakMaxMinutes,
      defaults.longBreakDuration.inMinutes,
    );
    final sessions = _clampOrDefault(
      prefs.getInt(keySessionsBeforeLongBreak),
      TimerSettings.sessionsMin,
      TimerSettings.sessionsMax,
      defaults.sessionsBeforeLongBreak,
    );

    return TimerSettings(
      workDuration: Duration(minutes: work),
      shortBreakDuration: Duration(minutes: shortBreak),
      longBreakDuration: Duration(minutes: longBreak),
      sessionsBeforeLongBreak: sessions,
      autoStartBreaks:
          prefs.getBool(keyAutoStartBreaks) ?? defaults.autoStartBreaks,
      autoStartNextWork:
          prefs.getBool(keyAutoStartNextWork) ?? defaults.autoStartNextWork,
      soundEnabled: prefs.getBool(keySoundEnabled) ?? defaults.soundEnabled,
      vibrationEnabled:
          prefs.getBool(keyVibrationEnabled) ?? defaults.vibrationEnabled,
    );
  }

  @override
  Future<void> save(TimerSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt(keyWorkMinutes, settings.workDuration.inMinutes),
      prefs.setInt(keyShortBreakMinutes, settings.shortBreakDuration.inMinutes),
      prefs.setInt(keyLongBreakMinutes, settings.longBreakDuration.inMinutes),
      prefs.setInt(
        keySessionsBeforeLongBreak,
        settings.sessionsBeforeLongBreak,
      ),
      prefs.setBool(keyAutoStartBreaks, settings.autoStartBreaks),
      prefs.setBool(keyAutoStartNextWork, settings.autoStartNextWork),
      prefs.setBool(keySoundEnabled, settings.soundEnabled),
      prefs.setBool(keyVibrationEnabled, settings.vibrationEnabled),
    ]);
  }

  int _clampOrDefault(int? value, int min, int max, int fallback) {
    if (value == null) return fallback;
    return value.clamp(min, max);
  }
}
