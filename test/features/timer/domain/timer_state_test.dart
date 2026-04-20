import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/features/timer/domain/pomodoro_session.dart';
import 'package:pomodoro/features/timer/domain/session_type.dart';
import 'package:pomodoro/features/timer/domain/timer_state.dart';
import 'package:pomodoro/features/timer/domain/timer_state_transitions.dart';

void main() {
  final startedAt = DateTime.utc(2026, 1, 1, 9);
  final completedAt = DateTime.utc(2026, 1, 1, 9, 25);
  final session = PomodoroSession(
    id: 'test-session-1',
    type: SessionType.work,
    duration: const Duration(minutes: 25),
    startedAt: startedAt,
  );

  group('TimerState transitions', () {
    test('Idle -> Running via start()', () {
      const TimerState idle = TimerIdle();

      final next = idle.start(session);

      expect(next, isA<TimerRunning>());
      final running = next as TimerRunning;
      expect(running.session, session);
      expect(running.elapsed, Duration.zero);
    });

    test('Running -> Paused via pause() preserves elapsed', () {
      const elapsed = Duration(minutes: 5);
      final running = TimerRunning(session: session, elapsed: elapsed);

      final next = running.pause();

      expect(next, isA<TimerPaused>());
      final paused = next as TimerPaused;
      expect(paused.session, session);
      expect(paused.elapsed, elapsed);
    });

    test('Paused -> Running via resume() preserves elapsed', () {
      const elapsed = Duration(minutes: 5);
      final paused = TimerPaused(session: session, elapsed: elapsed);

      final next = paused.resume();

      expect(next, isA<TimerRunning>());
      final running = next as TimerRunning;
      expect(running.session, session);
      expect(running.elapsed, elapsed);
    });

    test('Running -> Running via tick() accumulates elapsed', () {
      final running = TimerRunning(session: session);

      final next = running.tick(const Duration(seconds: 30));

      expect(next, isA<TimerRunning>());
      expect((next as TimerRunning).elapsed, const Duration(seconds: 30));
    });

    test('tick() caps elapsed at session.duration', () {
      final running = TimerRunning(
        session: session,
        elapsed: const Duration(minutes: 24, seconds: 59),
      );

      final next = running.tick(const Duration(seconds: 10));

      expect((next as TimerRunning).elapsed, session.duration);
    });

    test('Running -> Finished via finish() marks session completed', () {
      final running = TimerRunning(session: session, elapsed: session.duration);

      final next = running.finish(completedAt);

      expect(next, isA<TimerFinished>());
      final finished = next as TimerFinished;
      expect(finished.session.completed, isTrue);
      expect(finished.session.completedAt, completedAt);
      expect(finished.session.id, session.id);
    });

    test('Paused -> Finished via finish() marks session completed', () {
      final paused = TimerPaused(
        session: session,
        elapsed: const Duration(minutes: 10),
      );

      final next = paused.finish(completedAt);

      expect(next, isA<TimerFinished>());
      expect((next as TimerFinished).session.completed, isTrue);
    });

    test('pause() from Idle throws StateError', () {
      const TimerState idle = TimerIdle();

      expect(idle.pause, throwsStateError);
    });

    test('resume() from Running throws StateError', () {
      final running = TimerRunning(session: session);

      expect(running.resume, throwsStateError);
    });

    test('start() from Running throws StateError', () {
      final running = TimerRunning(session: session);

      expect(() => running.start(session), throwsStateError);
    });

    test('tick() from Paused throws StateError', () {
      final paused = TimerPaused(
        session: session,
        elapsed: const Duration(minutes: 1),
      );

      expect(() => paused.tick(const Duration(seconds: 1)), throwsStateError);
    });

    test('finish() from Idle throws StateError', () {
      const TimerState idle = TimerIdle();

      expect(() => idle.finish(completedAt), throwsStateError);
    });
  });
}
