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
  });

  final Duration workDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int sessionsBeforeLongBreak;

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerSettings &&
          runtimeType == other.runtimeType &&
          workDuration == other.workDuration &&
          shortBreakDuration == other.shortBreakDuration &&
          longBreakDuration == other.longBreakDuration &&
          sessionsBeforeLongBreak == other.sessionsBeforeLongBreak;

  @override
  int get hashCode => Object.hash(
    workDuration,
    shortBreakDuration,
    longBreakDuration,
    sessionsBeforeLongBreak,
  );
}

final timerSettingsProvider = Provider<TimerSettings>(
  (ref) => const TimerSettings(),
);
