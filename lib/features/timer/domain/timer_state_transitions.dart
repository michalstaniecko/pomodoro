import 'pomodoro_session.dart';
import 'timer_state.dart';

extension TimerStateTransitions on TimerState {
  TimerState start(PomodoroSession session) {
    if (this is! TimerIdle) {
      throw StateError(
        'start() dozwolony tylko z TimerIdle (aktualny: $runtimeType).',
      );
    }
    return TimerState.running(session: session);
  }

  TimerState pause() {
    final self = this;
    if (self is! TimerRunning) {
      throw StateError(
        'pause() dozwolony tylko z TimerRunning (aktualny: $runtimeType).',
      );
    }
    return TimerState.paused(session: self.session, elapsed: self.elapsed);
  }

  TimerState resume() {
    final self = this;
    if (self is! TimerPaused) {
      throw StateError(
        'resume() dozwolony tylko z TimerPaused (aktualny: $runtimeType).',
      );
    }
    return TimerState.running(session: self.session, elapsed: self.elapsed);
  }

  TimerState tick(Duration delta) {
    final self = this;
    if (self is! TimerRunning) {
      throw StateError(
        'tick() dozwolony tylko z TimerRunning (aktualny: $runtimeType).',
      );
    }
    final next = self.elapsed + delta;
    if (next >= self.session.duration) {
      return TimerState.running(
        session: self.session,
        elapsed: self.session.duration,
      );
    }
    return TimerState.running(session: self.session, elapsed: next);
  }

  TimerState finish(DateTime completedAt) {
    final self = this;
    if (self is! TimerRunning && self is! TimerPaused) {
      throw StateError(
        'finish() dozwolony tylko z TimerRunning/TimerPaused (aktualny: $runtimeType).',
      );
    }
    final session = self is TimerRunning
        ? self.session
        : (self as TimerPaused).session;
    return TimerState.finished(
      session: session.copyWith(completed: true, completedAt: completedAt),
    );
  }
}
