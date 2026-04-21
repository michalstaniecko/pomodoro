import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/features/settings/data/shared_preferences_settings_repository.dart';
import 'package:pomodoro/features/timer/application/timer_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesSettingsRepository', () {
    test('load returns defaults when prefs are empty', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPreferencesSettingsRepository();

      final settings = await repo.load();

      expect(settings, const TimerSettings());
    });

    test('save then load round-trips all fields', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SharedPreferencesSettingsRepository();

      const saved = TimerSettings(
        workDuration: Duration(minutes: 40),
        shortBreakDuration: Duration(minutes: 7),
        longBreakDuration: Duration(minutes: 20),
        sessionsBeforeLongBreak: 6,
        autoStartBreaks: true,
        autoStartNextWork: true,
        soundEnabled: false,
        vibrationEnabled: false,
      );

      await repo.save(saved);
      final loaded = await repo.load();

      expect(loaded, saved);
    });

    test('load clamps out-of-range values', () async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesSettingsRepository.keyWorkMinutes: 9999,
        SharedPreferencesSettingsRepository.keyShortBreakMinutes: 0,
        SharedPreferencesSettingsRepository.keyLongBreakMinutes: 9999,
        SharedPreferencesSettingsRepository.keySessionsBeforeLongBreak: 0,
      });
      final repo = SharedPreferencesSettingsRepository();

      final settings = await repo.load();

      expect(settings.workDuration.inMinutes, TimerSettings.workMaxMinutes);
      expect(
        settings.shortBreakDuration.inMinutes,
        TimerSettings.shortBreakMinMinutes,
      );
      expect(
        settings.longBreakDuration.inMinutes,
        TimerSettings.longBreakMaxMinutes,
      );
      expect(settings.sessionsBeforeLongBreak, TimerSettings.sessionsMin);
    });
  });
}
