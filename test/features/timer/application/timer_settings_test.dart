import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/features/timer/application/timer_settings.dart';

void main() {
  group('TimerSettings', () {
    test('default values', () {
      const s = TimerSettings();
      expect(s.workDuration, const Duration(minutes: 25));
      expect(s.shortBreakDuration, const Duration(minutes: 5));
      expect(s.longBreakDuration, const Duration(minutes: 15));
      expect(s.sessionsBeforeLongBreak, 4);
      expect(s.autoStartBreaks, isFalse);
      expect(s.autoStartNextWork, isFalse);
      expect(s.soundEnabled, isTrue);
      expect(s.vibrationEnabled, isTrue);
    });

    test('copyWith changes only provided fields', () {
      const s = TimerSettings();
      final updated = s.copyWith(
        workDuration: const Duration(minutes: 30),
        autoStartBreaks: true,
      );
      expect(updated.workDuration, const Duration(minutes: 30));
      expect(updated.autoStartBreaks, isTrue);
      expect(updated.shortBreakDuration, s.shortBreakDuration);
      expect(updated.longBreakDuration, s.longBreakDuration);
      expect(updated.sessionsBeforeLongBreak, s.sessionsBeforeLongBreak);
      expect(updated.autoStartNextWork, s.autoStartNextWork);
      expect(updated.soundEnabled, s.soundEnabled);
      expect(updated.vibrationEnabled, s.vibrationEnabled);
    });

    test('equality and hashCode', () {
      const a = TimerSettings();
      const b = TimerSettings();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      final c = a.copyWith(soundEnabled: false);
      expect(a, isNot(equals(c)));
    });
  });

  group('TimerSettingsNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('build returns defaults', () {
      expect(container.read(timerSettingsProvider), const TimerSettings());
    });

    test('setWorkMinutes updates state', () {
      container.read(timerSettingsProvider.notifier).setWorkMinutes(10);
      expect(
        container.read(timerSettingsProvider).workDuration,
        const Duration(minutes: 10),
      );
    });

    test('setWorkMinutes clamps below min', () {
      container.read(timerSettingsProvider.notifier).setWorkMinutes(1);
      expect(
        container.read(timerSettingsProvider).workDuration.inMinutes,
        TimerSettings.workMinMinutes,
      );
    });

    test('setWorkMinutes clamps above max', () {
      container.read(timerSettingsProvider.notifier).setWorkMinutes(100);
      expect(
        container.read(timerSettingsProvider).workDuration.inMinutes,
        TimerSettings.workMaxMinutes,
      );
    });

    test('setShortBreakMinutes clamps to range', () {
      final n = container.read(timerSettingsProvider.notifier);
      n.setShortBreakMinutes(0);
      expect(
        container.read(timerSettingsProvider).shortBreakDuration.inMinutes,
        TimerSettings.shortBreakMinMinutes,
      );
      n.setShortBreakMinutes(999);
      expect(
        container.read(timerSettingsProvider).shortBreakDuration.inMinutes,
        TimerSettings.shortBreakMaxMinutes,
      );
    });

    test('setLongBreakMinutes clamps to range', () {
      final n = container.read(timerSettingsProvider.notifier);
      n.setLongBreakMinutes(1);
      expect(
        container.read(timerSettingsProvider).longBreakDuration.inMinutes,
        TimerSettings.longBreakMinMinutes,
      );
      n.setLongBreakMinutes(999);
      expect(
        container.read(timerSettingsProvider).longBreakDuration.inMinutes,
        TimerSettings.longBreakMaxMinutes,
      );
    });

    test('setSessionsBeforeLongBreak clamps to range', () {
      final n = container.read(timerSettingsProvider.notifier);
      n.setSessionsBeforeLongBreak(0);
      expect(
        container.read(timerSettingsProvider).sessionsBeforeLongBreak,
        TimerSettings.sessionsMin,
      );
      n.setSessionsBeforeLongBreak(99);
      expect(
        container.read(timerSettingsProvider).sessionsBeforeLongBreak,
        TimerSettings.sessionsMax,
      );
    });

    test('setAutoStartBreaks toggles flag', () {
      container.read(timerSettingsProvider.notifier).setAutoStartBreaks(true);
      expect(container.read(timerSettingsProvider).autoStartBreaks, isTrue);
    });

    test('setAutoStartNextWork toggles flag', () {
      container.read(timerSettingsProvider.notifier).setAutoStartNextWork(true);
      expect(container.read(timerSettingsProvider).autoStartNextWork, isTrue);
    });

    test('setSoundEnabled toggles flag', () {
      container.read(timerSettingsProvider.notifier).setSoundEnabled(false);
      expect(container.read(timerSettingsProvider).soundEnabled, isFalse);
    });

    test('setVibrationEnabled toggles flag', () {
      container.read(timerSettingsProvider.notifier).setVibrationEnabled(false);
      expect(container.read(timerSettingsProvider).vibrationEnabled, isFalse);
    });
  });
}
