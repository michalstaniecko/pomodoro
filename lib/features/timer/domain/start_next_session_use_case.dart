import 'pomodoro_cycle.dart';
import 'session_type.dart';

typedef NextSessionResult = ({SessionType nextType, PomodoroCycle cycle});

class StartNextSessionUseCase {
  const StartNextSessionUseCase();

  NextSessionResult call({
    required PomodoroCycle cycle,
    SessionType? completedType,
  }) {
    if (completedType == null) {
      return (nextType: SessionType.work, cycle: cycle);
    }

    switch (completedType) {
      case SessionType.work:
        final incremented = cycle.completedWorkSessions + 1;
        final isLongBreakDue = incremented >= cycle.sessionsBeforeLongBreak;
        return (
          nextType: isLongBreakDue
              ? SessionType.longBreak
              : SessionType.shortBreak,
          cycle: cycle.copyWith(completedWorkSessions: incremented),
        );
      case SessionType.shortBreak:
        return (nextType: SessionType.work, cycle: cycle);
      case SessionType.longBreak:
        return (
          nextType: SessionType.work,
          cycle: cycle.copyWith(completedWorkSessions: 0),
        );
    }
  }
}
