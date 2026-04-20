import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/features/timer/domain/pomodoro_cycle.dart';
import 'package:pomodoro/features/timer/domain/session_type.dart';
import 'package:pomodoro/features/timer/domain/start_next_session_use_case.dart';

void main() {
  const useCase = StartNextSessionUseCase();

  group('StartNextSessionUseCase', () {
    test('start from empty state returns work without mutating cycle', () {
      const cycle = PomodoroCycle();

      final result = useCase(cycle: cycle, completedType: null);

      expect(result.nextType, SessionType.work);
      expect(result.cycle, cycle);
      expect(result.cycle.completedWorkSessions, 0);
      expect(result.cycle.sessionsBeforeLongBreak, 4);
    });

    test('after work (1/4) returns shortBreak and increments counter', () {
      const cycle = PomodoroCycle();

      final result = useCase(cycle: cycle, completedType: SessionType.work);

      expect(result.nextType, SessionType.shortBreak);
      expect(result.cycle.completedWorkSessions, 1);
    });

    test('after shortBreak returns work without changing counter', () {
      const cycle = PomodoroCycle(completedWorkSessions: 1);

      final result = useCase(
        cycle: cycle,
        completedType: SessionType.shortBreak,
      );

      expect(result.nextType, SessionType.work);
      expect(result.cycle.completedWorkSessions, 1);
    });

    test('after 4th work (default N=4) returns longBreak', () {
      const cycle = PomodoroCycle(completedWorkSessions: 3);

      final result = useCase(cycle: cycle, completedType: SessionType.work);

      expect(result.nextType, SessionType.longBreak);
      expect(result.cycle.completedWorkSessions, 4);
    });

    test('after longBreak returns work and resets counter to 0', () {
      const cycle = PomodoroCycle(completedWorkSessions: 4);

      final result = useCase(
        cycle: cycle,
        completedType: SessionType.longBreak,
      );

      expect(result.nextType, SessionType.work);
      expect(result.cycle.completedWorkSessions, 0);
    });

    test('full cycle with default sessionsBeforeLongBreak=4', () {
      PomodoroCycle cycle = const PomodoroCycle();

      final sequence = <SessionType>[];
      SessionType? last;

      for (var i = 0; i < 9; i++) {
        final result = useCase(cycle: cycle, completedType: last);
        sequence.add(result.nextType);
        cycle = result.cycle;
        last = result.nextType;
      }

      expect(sequence, <SessionType>[
        SessionType.work,
        SessionType.shortBreak,
        SessionType.work,
        SessionType.shortBreak,
        SessionType.work,
        SessionType.shortBreak,
        SessionType.work,
        SessionType.longBreak,
        SessionType.work,
      ]);
      expect(cycle.completedWorkSessions, 0);
    });

    test('full cycle with custom sessionsBeforeLongBreak=2', () {
      PomodoroCycle cycle = const PomodoroCycle(sessionsBeforeLongBreak: 2);

      final sequence = <SessionType>[];
      SessionType? last;

      for (var i = 0; i < 5; i++) {
        final result = useCase(cycle: cycle, completedType: last);
        sequence.add(result.nextType);
        cycle = result.cycle;
        last = result.nextType;
      }

      expect(sequence, <SessionType>[
        SessionType.work,
        SessionType.shortBreak,
        SessionType.work,
        SessionType.longBreak,
        SessionType.work,
      ]);
      expect(cycle.completedWorkSessions, 0);
    });

    test('counter resets only after longBreak, not after shortBreak', () {
      const cycle = PomodoroCycle(completedWorkSessions: 2);

      final afterShort = useCase(
        cycle: cycle,
        completedType: SessionType.shortBreak,
      );

      expect(afterShort.cycle.completedWorkSessions, 2);
    });

    test('custom N=1 triggers longBreak immediately after first work', () {
      const cycle = PomodoroCycle(sessionsBeforeLongBreak: 1);

      final result = useCase(cycle: cycle, completedType: SessionType.work);

      expect(result.nextType, SessionType.longBreak);
      expect(result.cycle.completedWorkSessions, 1);
    });

    test('sessionsBeforeLongBreak < 1 throws AssertionError', () {
      expect(
        () => PomodoroCycle(sessionsBeforeLongBreak: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => PomodoroCycle(sessionsBeforeLongBreak: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('completedWorkSessions < 0 throws AssertionError', () {
      expect(
        () => PomodoroCycle(completedWorkSessions: -1),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
