import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/pomodoro_session.dart';
import '../domain/session_type.dart';
import '../domain/start_next_session_use_case.dart';
import '../domain/timer_state.dart';
import '../domain/timer_state_transitions.dart';
import 'clock.dart';
import 'cycle_controller.dart';
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

  void start() {
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
    state = state.start(session);
    _startTicking();
  }

  void pause() {
    state = state.pause();
    _stopTicking();
  }

  void resume() {
    state = state.resume();
    _startTicking();
  }

  void stop() {
    final current = state;
    final SessionType cancelledType;
    if (current is TimerRunning) {
      cancelledType = current.session.type;
    } else if (current is TimerPaused) {
      cancelledType = current.session.type;
    } else {
      throw StateError(
        'stop() dozwolony tylko z TimerRunning/TimerPaused (aktualny: ${current.runtimeType}).',
      );
    }
    _stopTicking();
    state = TimerState.idle(nextSessionType: cancelledType);
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
    final cycle = ref.read(cycleControllerProvider);
    final result = ref.read(startNextSessionUseCaseProvider)(
      cycle: cycle,
      completedType: skippedType,
    );
    ref.read(cycleControllerProvider.notifier).set(result.cycle);
    state = TimerState.idle(nextSessionType: result.nextType);
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
    final next = current.tick(_tickInterval) as TimerRunning;
    if (next.elapsed >= next.session.duration) {
      _completeCurrentSession(next);
    } else {
      state = next;
    }
  }

  void _completeCurrentSession(TimerRunning running) {
    _stopTicking();
    final finishedAt = ref.read(clockProvider)();
    final finished = running.finish(finishedAt) as TimerFinished;
    state = finished;
    if (!_events.isClosed) {
      _events.add(
        SessionFinishedEvent(session: finished.session, finishedAt: finishedAt),
      );
    }
    final cycle = ref.read(cycleControllerProvider);
    final result = ref.read(startNextSessionUseCaseProvider)(
      cycle: cycle,
      completedType: finished.session.type,
    );
    ref.read(cycleControllerProvider.notifier).set(result.cycle);
    state = TimerState.idle(nextSessionType: result.nextType);
  }
}
