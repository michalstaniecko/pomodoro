import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/features/timer/application/clock.dart';
import 'package:pomodoro/features/timer/application/session_finished_event.dart';
import 'package:pomodoro/features/timer/application/ticker.dart';
import 'package:pomodoro/features/timer/application/timer_controller.dart';
import 'package:pomodoro/features/timer/application/timer_settings.dart';
import 'package:pomodoro/features/timer/domain/session_type.dart';
import 'package:pomodoro/features/timer/domain/timer_state.dart';

class FakeTicker implements Ticker {
  final StreamController<void> _controller = StreamController<void>.broadcast();

  void fire() => _controller.add(null);

  void fireN(int n) {
    for (var i = 0; i < n; i++) {
      _controller.add(null);
    }
  }

  Future<void> close() => _controller.close();

  @override
  Stream<void> tick({required Duration interval}) => _controller.stream;
}

void main() {
  late FakeTicker ticker;
  late DateTime now;
  late ProviderContainer container;

  const testSettings = TimerSettings(
    workDuration: Duration(seconds: 3),
    shortBreakDuration: Duration(seconds: 2),
    longBreakDuration: Duration(seconds: 4),
    sessionsBeforeLongBreak: 2,
  );

  setUp(() {
    ticker = FakeTicker();
    now = DateTime.utc(2026, 1, 1, 9);
    container = ProviderContainer(
      overrides: [
        tickerProvider.overrideWithValue(ticker),
        clockProvider.overrideWithValue(() => now),
        timerSettingsProvider.overrideWithValue(testSettings),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(ticker.close);
  });

  Future<void> pump() => Future<void>.delayed(Duration.zero);

  group('TimerController', () {
    test('initial state is TimerIdle with nextSessionType=work', () {
      expect(container.read(timerControllerProvider), const TimerState.idle());
    });

    test('start() transitions Idle -> Running with fresh session', () {
      container.read(timerControllerProvider.notifier).start();

      final state = container.read(timerControllerProvider);
      expect(state, isA<TimerRunning>());
      final running = state as TimerRunning;
      expect(running.session.type, SessionType.work);
      expect(running.session.duration, testSettings.workDuration);
      expect(running.session.startedAt, now);
      expect(running.elapsed, Duration.zero);
    });

    test('tick advances elapsed by 1s per tick', () async {
      container.read(timerControllerProvider.notifier).start();
      ticker.fire();
      await pump();

      final running = container.read(timerControllerProvider) as TimerRunning;
      expect(running.elapsed, const Duration(seconds: 1));
    });

    test('pause() stops ticks; resume() continues', () async {
      final controller = container.read(timerControllerProvider.notifier);
      controller.start();
      ticker.fire();
      await pump();

      controller.pause();
      expect(container.read(timerControllerProvider), isA<TimerPaused>());

      ticker.fire();
      await pump();
      final paused = container.read(timerControllerProvider) as TimerPaused;
      expect(paused.elapsed, const Duration(seconds: 1));

      controller.resume();
      ticker.fire();
      await pump();
      final running = container.read(timerControllerProvider) as TimerRunning;
      expect(running.elapsed, const Duration(seconds: 2));
    });

    test('stop() from Running returns to Idle with same nextSessionType', () {
      final controller = container.read(timerControllerProvider.notifier);
      controller.start();
      controller.stop();

      final state = container.read(timerControllerProvider);
      expect(state, isA<TimerIdle>());
      expect((state as TimerIdle).nextSessionType, SessionType.work);
    });

    test('skip() advances cycle to next session type without event', () async {
      final events = <SessionFinishedEvent>[];
      final sub = container
          .read(timerControllerProvider.notifier)
          .events
          .listen(events.add);
      addTearDown(sub.cancel);

      final controller = container.read(timerControllerProvider.notifier);
      controller.start();
      controller.skip();
      await pump();

      final state = container.read(timerControllerProvider) as TimerIdle;
      expect(state.nextSessionType, SessionType.shortBreak);
      expect(events, isEmpty);
    });

    test('session auto-completes and emits event at duration', () async {
      final events = <SessionFinishedEvent>[];
      final sub = container
          .read(timerControllerProvider.notifier)
          .events
          .listen(events.add);
      addTearDown(sub.cancel);

      container.read(timerControllerProvider.notifier).start();
      ticker.fireN(3);
      await pump();

      expect(events, hasLength(1));
      expect(events.single.session.type, SessionType.work);
      expect(events.single.session.completed, isTrue);
      expect(events.single.finishedAt, now);

      final state = container.read(timerControllerProvider) as TimerIdle;
      expect(state.nextSessionType, SessionType.shortBreak);
    });

    test('full cycle: work -> short -> work -> longBreak', () async {
      final events = <SessionFinishedEvent>[];
      final sub = container
          .read(timerControllerProvider.notifier)
          .events
          .listen(events.add);
      addTearDown(sub.cancel);

      final controller = container.read(timerControllerProvider.notifier);

      controller.start();
      ticker.fireN(3);
      await pump();
      expect(
        (container.read(timerControllerProvider) as TimerIdle).nextSessionType,
        SessionType.shortBreak,
      );

      controller.start();
      ticker.fireN(2);
      await pump();
      expect(
        (container.read(timerControllerProvider) as TimerIdle).nextSessionType,
        SessionType.work,
      );

      controller.start();
      ticker.fireN(3);
      await pump();
      expect(
        (container.read(timerControllerProvider) as TimerIdle).nextSessionType,
        SessionType.longBreak,
      );

      expect(events.map((e) => e.session.type).toList(), <SessionType>[
        SessionType.work,
        SessionType.shortBreak,
        SessionType.work,
      ]);
    });

    test('start() from Running throws StateError', () {
      final controller = container.read(timerControllerProvider.notifier);
      controller.start();

      expect(controller.start, throwsStateError);
    });

    test('stop() from Idle throws StateError', () {
      final controller = container.read(timerControllerProvider.notifier);

      expect(controller.stop, throwsStateError);
    });

    test('skip() from Idle throws StateError', () {
      final controller = container.read(timerControllerProvider.notifier);

      expect(controller.skip, throwsStateError);
    });

    test(
      'sessionFinishedEventsProvider exposes events as StreamProvider',
      () async {
        final events = <SessionFinishedEvent>[];
        final sub = container.listen<AsyncValue<SessionFinishedEvent>>(
          sessionFinishedEventsProvider,
          (_, next) {
            final value = next.valueOrNull;
            if (value != null) events.add(value);
          },
        );
        addTearDown(sub.close);

        container.read(timerControllerProvider.notifier).start();
        ticker.fireN(3);
        await pump();

        expect(events, hasLength(1));
      },
    );
  });
}
