import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/session_type.dart';

@immutable
class TimerSettings {
  const TimerSettings({
    this.workDuration = const Duration(minutes: 25),
    this.shortBreakDuration = const Duration(minutes: 5),
    this.longBreakDuration = const Duration(minutes: 15),
    this.sessionsBeforeLongBreak = 4,
    this.autoStartBreaks = false,
    this.autoStartNextWork = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  static const int workMinMinutes = 5;
  static const int workMaxMinutes = 90;
  static const int shortBreakMinMinutes = 1;
  static const int shortBreakMaxMinutes = 30;
  static const int longBreakMinMinutes = 5;
  static const int longBreakMaxMinutes = 60;
  static const int sessionsMin = 2;
  static const int sessionsMax = 8;

  final Duration workDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int sessionsBeforeLongBreak;
  final bool autoStartBreaks;
  final bool autoStartNextWork;
  final bool soundEnabled;
  final bool vibrationEnabled;

  Duration durationFor(SessionType type) {
    switch (type) {
      case SessionType.work:
        return workDuration;
      case SessionType.shortBreak:
        return shortBreakDuration;
      case SessionType.longBreak:
        return longBreakDuration;
    }
  }

  TimerSettings copyWith({
    Duration? workDuration,
    Duration? shortBreakDuration,
    Duration? longBreakDuration,
    int? sessionsBeforeLongBreak,
    bool? autoStartBreaks,
    bool? autoStartNextWork,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return TimerSettings(
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsBeforeLongBreak:
          sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartNextWork: autoStartNextWork ?? this.autoStartNextWork,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerSettings &&
          runtimeType == other.runtimeType &&
          workDuration == other.workDuration &&
          shortBreakDuration == other.shortBreakDuration &&
          longBreakDuration == other.longBreakDuration &&
          sessionsBeforeLongBreak == other.sessionsBeforeLongBreak &&
          autoStartBreaks == other.autoStartBreaks &&
          autoStartNextWork == other.autoStartNextWork &&
          soundEnabled == other.soundEnabled &&
          vibrationEnabled == other.vibrationEnabled;

  @override
  int get hashCode => Object.hash(
    workDuration,
    shortBreakDuration,
    longBreakDuration,
    sessionsBeforeLongBreak,
    autoStartBreaks,
    autoStartNextWork,
    soundEnabled,
    vibrationEnabled,
  );
}

class TimerSettingsNotifier extends Notifier<TimerSettings> {
  @override
  TimerSettings build() => const TimerSettings();

  void setWorkMinutes(int minutes) {
    final clamped = minutes.clamp(
      TimerSettings.workMinMinutes,
      TimerSettings.workMaxMinutes,
    );
    state = state.copyWith(workDuration: Duration(minutes: clamped));
  }

  void setShortBreakMinutes(int minutes) {
    final clamped = minutes.clamp(
      TimerSettings.shortBreakMinMinutes,
      TimerSettings.shortBreakMaxMinutes,
    );
    state = state.copyWith(shortBreakDuration: Duration(minutes: clamped));
  }

  void setLongBreakMinutes(int minutes) {
    final clamped = minutes.clamp(
      TimerSettings.longBreakMinMinutes,
      TimerSettings.longBreakMaxMinutes,
    );
    state = state.copyWith(longBreakDuration: Duration(minutes: clamped));
  }

  void setSessionsBeforeLongBreak(int count) {
    final clamped = count.clamp(
      TimerSettings.sessionsMin,
      TimerSettings.sessionsMax,
    );
    state = state.copyWith(sessionsBeforeLongBreak: clamped);
  }

  void setAutoStartBreaks(bool value) {
    state = state.copyWith(autoStartBreaks: value);
  }

  void setAutoStartNextWork(bool value) {
    state = state.copyWith(autoStartNextWork: value);
  }

  void setSoundEnabled(bool value) {
    state = state.copyWith(soundEnabled: value);
  }

  void setVibrationEnabled(bool value) {
    state = state.copyWith(vibrationEnabled: value);
  }
}

final timerSettingsProvider =
    NotifierProvider<TimerSettingsNotifier, TimerSettings>(
      TimerSettingsNotifier.new,
    );
