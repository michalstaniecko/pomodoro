import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/pomodoro_session.dart';
import '../domain/session_display_labels.dart';
import '../domain/session_type.dart';
import '../domain/start_next_session_use_case.dart';
import '../domain/timer_state.dart';
import '../domain/timer_state_transitions.dart';
import 'clock.dart';
import 'cycle_controller.dart';
import 'foreground_service_providers.dart';
import 'session_finished_event.dart';
import 'ticker.dart';
import 'timer_settings.dart';

final startNextSessionUseCaseProvider = Provider<StartNextSessionUseCase>(
  (ref) => const StartNextSessionUseCase(),
);

final timerControllerProvider = NotifierProvider<TimerController, TimerState>(
  TimerController.new,
);

final sessionFinishedEventsProvider = StreamProvider<SessionFinishedEvent>(
  (ref) => ref.watch(timerControllerProvider.notifier).events,
);

class TimerController extends Notifier<TimerState> {
  StreamSubscription<void>? _tickerSub;
  final StreamController<SessionFinishedEvent> _events =
      StreamController<SessionFinishedEvent>.broadcast();
  bool _disposed = false;

  // Wall-clock pause tracking: akumulujemy czas w stanie Paused, aby elapsed
  // liczyło się z `now - startedAt - _accumulatedPaused`, odpornie na zawieszenia
  // isolate'u (lock screen / doze mode).
  DateTime? _pausedAt;
  Duration _accumulatedPaused = Duration.zero;

  static const Duration _tickInterval = Duration(seconds: 1);

  Stream<SessionFinishedEvent> get events => _events.stream;

  @override
  TimerState build() {
    ref.onDispose(() {
      _disposed = true;
      unawaited(_tickerSub?.cancel());
      unawaited(_events.close());
    });

    return const TimerState.idle();
  }

  void start({SessionDisplayLabels? labels}) {
    final current = state;
    if (current is! TimerIdle) {
      throw StateError(
        'start() dozwolony tylko z TimerIdle (aktualny: ${current.runtimeType}).',
      );
    }
    final type = current.nextSessionType;
    final now = ref.read(clockProvider)();
    final settings = ref.read(timerSettingsProvider);
    final session = PomodoroSession(
      id: now.microsecondsSinceEpoch.toString(),
      type: type,
      duration: settings.durationFor(type),
      startedAt: now,
    );
    _pausedAt = null;
    _accumulatedPaused = Duration.zero;
    state = state.start(session);
    _startTicking();
    if (labels != null) {
      unawaited(
        ref
            .read(pomodoroForegroundServiceProvider)
            .start(type: type, total: session.duration, labels: labels),
      );
    }
  }

  void pause() {
    final before = state;
    if (before is! TimerRunning) {
      throw StateError(
        'pause() dozwolony tylko z TimerRunning (aktualny: ${before.runtimeType}).',
      );
    }
    final now = ref.read(clockProvider)();
    _pausedAt = now;
    final elapsed = _clampNonNeg(
      now.difference(before.session.startedAt) - _accumulatedPaused,
    );
    state = TimerState.paused(session: before.session, elapsed: elapsed);
    _stopTicking();
    final remaining = before.session.duration - elapsed;
    unawaited(
      ref
          .read(pomodoroForegroundServiceProvider)
          .pause(remaining: remaining.isNegative ? Duration.zero : remaining),
    );
  }

  void resume() {
    final before = state;
    if (before is! TimerPaused) {
      throw StateError(
        'resume() dozwolony tylko z TimerPaused (aktualny: ${before.runtimeType}).',
      );
    }
    final now = ref.read(clockProvider)();
    if (_pausedAt != null) {
      _accumulatedPaused += now.difference(_pausedAt!);
    }
    _pausedAt = null;
    final elapsed = _clampNonNeg(
      now.difference(before.session.startedAt) - _accumulatedPaused,
    );
    state = TimerState.running(session: before.session, elapsed: elapsed);
    _startTicking();
    final remaining = before.session.duration - elapsed;
    unawaited(
      ref
          .read(pomodoroForegroundServiceProvider)
          .resume(remaining: remaining.isNegative ? Duration.zero : remaining),
    );
  }

  void stop() {
    final current = state;
    final PomodoroSession cancelledSession;
    if (current is TimerRunning) {
      cancelledSession = current.session;
    } else if (current is TimerPaused) {
      cancelledSession = current.session;
    } else {
      throw StateError(
        'stop() dozwolony tylko z TimerRunning/TimerPaused (aktualny: ${current.runtimeType}).',
      );
    }
    _stopTicking();
    final finishedAt = ref.read(clockProvider)();
    if (!_events.isClosed) {
      _events.add(
        SessionFinishedEvent(
          session: cancelledSession.copyWith(completedAt: finishedAt),
          finishedAt: finishedAt,
          nextType: cancelledSession.type,
        ),
      );
    }
    _pausedAt = null;
    _accumulatedPaused = Duration.zero;
    state = TimerState.idle(nextSessionType: cancelledSession.type);
    unawaited(ref.read(pomodoroForegroundServiceProvider).stop());
  }

  void skip() {
    final current = state;
    final SessionType skippedType;
    if (current is TimerRunning) {
      skippedType = current.session.type;
    } else if (current is TimerPaused) {
      skippedType = current.session.type;
    } else {
      throw StateError(
        'skip() dozwolony tylko z TimerRunning/TimerPaused (aktualny: ${current.runtimeType}).',
      );
    }
    _stopTicking();
    _pausedAt = null;
    _accumulatedPaused = Duration.zero;
    final cycle = ref.read(cycleControllerProvider);
    final result = ref.read(startNextSessionUseCaseProvider)(
      cycle: cycle,
      completedType: skippedType,
    );
    ref.read(cycleControllerProvider.notifier).set(result.cycle);
    state = TimerState.idle(nextSessionType: result.nextType);
    unawaited(ref.read(pomodoroForegroundServiceProvider).stop());
  }

  /// Wywołane przez WidgetsBindingObserver po `AppLifecycleState.resumed`,
  /// aby dogonić elapsed po zawieszeniu isolate'u w tle.
  void onAppResumed() {
    _onTick();
  }

  void _startTicking() {
    unawaited(_tickerSub?.cancel());
    _tickerSub = ref
        .read(tickerProvider)
        .tick(interval: _tickInterval)
        .listen((_) => _onTick());
  }

  void _stopTicking() {
    unawaited(_tickerSub?.cancel());
    _tickerSub = null;
  }

  void _onTick() {
    if (_disposed) {
      return;
    }
    final current = state;
    if (current is! TimerRunning) {
      return;
    }
    final now = ref.read(clockProvider)();
    final elapsed = _clampNonNeg(
      now.difference(current.session.startedAt) - _accumulatedPaused,
    );
    if (elapsed >= current.session.duration) {
      _completeCurrentSession(current);
    } else {
      state = TimerState.running(session: current.session, elapsed: elapsed);
    }
  }

  void _completeCurrentSession(TimerRunning running) {
    _stopTicking();
    // finishedAt = moment, w którym sesja faktycznie się skończyła (nie moment
    // wykrycia — chroni przed driftem gdy isolate obudzi się z opóźnieniem).
    final finishedAt = running.session.startedAt
        .add(_accumulatedPaused)
        .add(running.session.duration);
    final completedSession = running.session.copyWith(
      completed: true,
      completedAt: finishedAt,
    );
    state = TimerState.finished(session: completedSession);
    _pausedAt = null;
    _accumulatedPaused = Duration.zero;
    final cycle = ref.read(cycleControllerProvider);
    final result = ref.read(startNextSessionUseCaseProvider)(
      cycle: cycle,
      completedType: completedSession.type,
    );
    ref.read(cycleControllerProvider.notifier).set(result.cycle);
    if (!_events.isClosed) {
      _events.add(
        SessionFinishedEvent(
          session: completedSession,
          finishedAt: finishedAt,
          nextType: result.nextType,
        ),
      );
    }
    state = TimerState.idle(nextSessionType: result.nextType);
    unawaited(ref.read(pomodoroForegroundServiceProvider).stop());
  }

  static Duration _clampNonNeg(Duration d) =>
      d < Duration.zero ? Duration.zero : d;
}
