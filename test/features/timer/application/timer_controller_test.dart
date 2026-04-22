import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/features/timer/application/clock.dart';
import 'package:pomodoro/features/timer/application/foreground_service_providers.dart';
import 'package:pomodoro/features/timer/application/session_finished_event.dart';
import 'package:pomodoro/features/timer/application/ticker.dart';
import 'package:pomodoro/features/timer/application/timer_controller.dart';
import 'package:pomodoro/features/timer/application/timer_settings.dart';
import 'package:pomodoro/features/timer/data/pomodoro_foreground_service.dart';
import 'package:pomodoro/features/timer/data/timer_state_repository.dart';
import 'package:pomodoro/features/timer/domain/pomodoro_session.dart';
import 'package:pomodoro/features/timer/domain/session_display_labels.dart';
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
  late _FakeForegroundService service;
  late _FakeTimerStateRepository fakeRepo;

  const testSettings = TimerSettings(
    workDuration: Duration(seconds: 3),
    shortBreakDuration: Duration(seconds: 2),
    longBreakDuration: Duration(seconds: 4),
    sessionsBeforeLongBreak: 2,
  );

  setUp(() {
    ticker = FakeTicker();
    now = DateTime.utc(2026, 1, 1, 9);
    service = _FakeForegroundService();
    fakeRepo = _FakeTimerStateRepository();
    container = ProviderContainer(
      overrides: [
        tickerProvider.overrideWithValue(ticker),
        clockProvider.overrideWithValue(() => now),
        timerSettingsProvider.overrideWith(
          () => _FixedTimerSettingsNotifier(testSettings),
        ),
        pomodoroForegroundServiceProvider.overrideWithValue(service),
        timerStateRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(ticker.close);
  });

  Future<void> pump() => Future<void>.delayed(Duration.zero);

  group('TimerController', () {
    // Helper: advance wall clock and fire one tick.
    void advanceAndTick([Duration delta = const Duration(seconds: 1)]) {
      now = now.add(delta);
      ticker.fire();
    }

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
      advanceAndTick();
      await pump();

      final running = container.read(timerControllerProvider) as TimerRunning;
      expect(running.elapsed, const Duration(seconds: 1));
    });

    test('pause() stops ticks; resume() continues', () async {
      final controller = container.read(timerControllerProvider.notifier);
      controller.start();
      advanceAndTick();
      await pump();

      controller.pause();
      expect(container.read(timerControllerProvider), isA<TimerPaused>());

      // Pauza trwa 1s — elapsed nie rośnie mimo tick'u.
      now = now.add(const Duration(seconds: 1));
      ticker.fire();
      await pump();
      final paused = container.read(timerControllerProvider) as TimerPaused;
      expect(paused.elapsed, const Duration(seconds: 1));

      controller.resume();
      advanceAndTick();
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

    test(
      'stop() from Running emits SessionFinishedEvent with completed=false',
      () async {
        final events = <SessionFinishedEvent>[];
        final sub = container
            .read(timerControllerProvider.notifier)
            .events
            .listen(events.add);
        addTearDown(sub.cancel);

        final controller = container.read(timerControllerProvider.notifier);
        controller.start();
        controller.stop();
        await pump();

        expect(events, hasLength(1));
        expect(events.single.session.completed, isFalse);
        expect(events.single.session.type, SessionType.work);
        expect(events.single.finishedAt, now);
      },
    );

    test(
      'stop() from Paused emits SessionFinishedEvent with completed=false',
      () async {
        final events = <SessionFinishedEvent>[];
        final sub = container
            .read(timerControllerProvider.notifier)
            .events
            .listen(events.add);
        addTearDown(sub.cancel);

        final controller = container.read(timerControllerProvider.notifier);
        controller.start();
        advanceAndTick();
        await pump();
        controller.pause();
        controller.stop();
        await pump();

        expect(events, hasLength(1));
        expect(events.single.session.completed, isFalse);
      },
    );

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

      final startedAt = now;
      container.read(timerControllerProvider.notifier).start();
      advanceAndTick();
      advanceAndTick();
      advanceAndTick();
      await pump();

      expect(events, hasLength(1));
      expect(events.single.session.type, SessionType.work);
      expect(events.single.session.completed, isTrue);
      expect(
        events.single.finishedAt,
        startedAt.add(testSettings.workDuration),
      );

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
      advanceAndTick();
      advanceAndTick();
      advanceAndTick();
      await pump();
      expect(
        (container.read(timerControllerProvider) as TimerIdle).nextSessionType,
        SessionType.shortBreak,
      );

      controller.start();
      advanceAndTick();
      advanceAndTick();
      await pump();
      expect(
        (container.read(timerControllerProvider) as TimerIdle).nextSessionType,
        SessionType.work,
      );

      controller.start();
      advanceAndTick();
      advanceAndTick();
      advanceAndTick();
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

    test('start/pause/resume/stop delegują do foreground service', () async {
      final controller = container.read(timerControllerProvider.notifier);
      const labels = SessionDisplayLabels(
        work: 'Work',
        shortBreak: 'Short',
        longBreak: 'Long',
        pause: 'Pause',
        resume: 'Resume',
        stop: 'Stop',
      );

      controller.start(labels: labels);
      expect(service.starts, 1);

      controller.pause();
      expect(service.pauses, 1);

      controller.resume();
      expect(service.resumes, 1);

      controller.stop();
      expect(service.stops, 1);
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
        now = now.add(const Duration(seconds: 3));
        ticker.fire();
        await pump();

        expect(events, hasLength(1));
      },
    );

    test(
      'wall-clock: elapsed odzwierciedla gap bez ticków po onAppResumed()',
      () async {
        final controller = container.read(timerControllerProvider.notifier);
        final startedAt = now;
        controller.start();

        // Symulacja zawieszenia isolate'u: 2s mija, ale brak ticków.
        now = startedAt.add(const Duration(seconds: 2));

        controller.onAppResumed();
        await pump();

        final running = container.read(timerControllerProvider) as TimerRunning;
        expect(running.elapsed, const Duration(seconds: 2));
      },
    );

    test(
      'sesja zakończona w tle -> _completeCurrentSession po wznowieniu',
      () async {
        final events = <SessionFinishedEvent>[];
        final sub = container
            .read(timerControllerProvider.notifier)
            .events
            .listen(events.add);
        addTearDown(sub.cancel);

        final controller = container.read(timerControllerProvider.notifier);
        final startedAt = now;
        controller.start();

        // 5s w tle > workDuration (3s) — sesja powinna się ukończyć po resume.
        now = startedAt.add(const Duration(seconds: 5));
        controller.onAppResumed();
        await pump();

        expect(events, hasLength(1));
        expect(events.single.session.completed, isTrue);
        expect(
          events.single.finishedAt,
          startedAt.add(testSettings.workDuration),
        );

        final state = container.read(timerControllerProvider) as TimerIdle;
        expect(state.nextSessionType, SessionType.shortBreak);
      },
    );

    test('finishedAt = startedAt + duration (a nie resume time)', () async {
      final events = <SessionFinishedEvent>[];
      final sub = container
          .read(timerControllerProvider.notifier)
          .events
          .listen(events.add);
      addTearDown(sub.cancel);

      final controller = container.read(timerControllerProvider.notifier);
      final startedAt = now;
      controller.start();

      // Wznowienie 10s po starcie — finishedAt MUSI być startedAt + 3s.
      now = startedAt.add(const Duration(seconds: 10));
      controller.onAppResumed();
      await pump();

      expect(
        events.single.finishedAt,
        startedAt.add(testSettings.workDuration),
      );
    });

    test(
      'pauza: accumulatedPaused nie doliczony do elapsed po resume',
      () async {
        final controller = container.read(timerControllerProvider.notifier);
        final startedAt = now;
        controller.start();

        now = startedAt.add(const Duration(seconds: 1));
        controller.pause();
        final paused = container.read(timerControllerProvider) as TimerPaused;
        expect(paused.elapsed, const Duration(seconds: 1));

        // Pauza trwa 5s.
        now = now.add(const Duration(seconds: 5));
        controller.resume();
        final running = container.read(timerControllerProvider) as TimerRunning;
        expect(running.elapsed, const Duration(seconds: 1));

        // Po 1s działania: elapsed = 2s (5s pauzy nie wlicza się).
        now = now.add(const Duration(seconds: 1));
        ticker.fire();
        await pump();
        final running2 =
            container.read(timerControllerProvider) as TimerRunning;
        expect(running2.elapsed, const Duration(seconds: 2));
      },
    );
  });

  group('edge cases — lock screen / doze / restart / battery saver', () {
    test(
      'AC1: sesja przeżywa długie zablokowanie ekranu (gap > duration)',
      () async {
        final events = <SessionFinishedEvent>[];
        final sub = container
            .read(timerControllerProvider.notifier)
            .events
            .listen(events.add);
        addTearDown(sub.cancel);

        final controller = container.read(timerControllerProvider.notifier);
        final startedAt = now;
        controller.start();

        // Lock screen — zero ticków przez czas znacznie dłuższy niż workDuration.
        // (testSettings.workDuration=3s, symulujemy 25x workDuration.)
        now = startedAt.add(testSettings.workDuration * 25);
        controller.onAppResumed();
        await pump();

        expect(events, hasLength(1));
        expect(events.single.session.completed, isTrue);
        expect(
          events.single.finishedAt,
          startedAt.add(testSettings.workDuration),
        );
      },
    );

    test('AC4: doze mode — ticki wstrzymane, wall-clock kompensuje', () async {
      final controller = container.read(timerControllerProvider.notifier);
      final startedAt = now;
      controller.start();

      now = startedAt.add(const Duration(seconds: 2));
      controller.onAppResumed();
      await pump();

      final running = container.read(timerControllerProvider) as TimerRunning;
      expect(running.elapsed, const Duration(seconds: 2));

      // Kolejny doze — sesja kończy się w tle.
      now = startedAt.add(const Duration(seconds: 4));
      controller.onAppResumed();
      await pump();
      expect(container.read(timerControllerProvider), isA<TimerIdle>());
    });

    test(
      'AC3: battery saver — nieregularne ticki nie psują elapsed (wall-clock)',
      () async {
        final controller = container.read(timerControllerProvider.notifier);
        final startedAt = now;
        controller.start();

        now = startedAt.add(const Duration(milliseconds: 2000));
        ticker.fire();
        await pump();
        expect(
          (container.read(timerControllerProvider) as TimerRunning).elapsed,
          const Duration(milliseconds: 2000),
        );

        // Dłuższa luka między tickami (battery saver throttling).
        now = startedAt.add(const Duration(milliseconds: 2500));
        ticker.fire();
        await pump();
        expect(
          (container.read(timerControllerProvider) as TimerRunning).elapsed,
          const Duration(milliseconds: 2500),
        );
      },
    );

    test('AC2: persist — start zapisuje stan do repo', () async {
      final controller = container.read(timerControllerProvider.notifier);
      controller.start();
      await pump();

      expect(fakeRepo.saves, greaterThanOrEqualTo(1));
      final loaded = await fakeRepo.load();
      expect(loaded, isNotNull);
      expect(loaded!.state, isA<TimerRunning>());
    });

    test('AC2: persist — stop czyści repo', () async {
      final controller = container.read(timerControllerProvider.notifier);
      controller.start();
      controller.stop();
      await pump();

      final loaded = await fakeRepo.load();
      expect(loaded, isNull);
    });

    test('AC2: restart odtwarza TimerPaused z zachowanym elapsed', () async {
      final controller = container.read(timerControllerProvider.notifier);
      final startedAt = now;
      controller.start();
      now = startedAt.add(const Duration(seconds: 1));
      ticker.fire();
      await pump();
      controller.pause();
      await pump();

      final saved = await fakeRepo.load();
      expect(saved, isNotNull);
      expect(saved!.state, isA<TimerPaused>());
      expect((saved.state as TimerPaused).elapsed, const Duration(seconds: 1));

      // Symulacja restartu — nowy ProviderContainer reużywający fakeRepo.
      final ticker2 = FakeTicker();
      addTearDown(ticker2.close);
      final service2 = _FakeForegroundService();
      final container2 = ProviderContainer(
        overrides: [
          tickerProvider.overrideWithValue(ticker2),
          clockProvider.overrideWithValue(() => now),
          timerSettingsProvider.overrideWith(
            () => _FixedTimerSettingsNotifier(testSettings),
          ),
          pomodoroForegroundServiceProvider.overrideWithValue(service2),
          timerStateRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container2.dispose);

      container2.read(timerControllerProvider);
      await pump();
      await pump();

      final restored = container2.read(timerControllerProvider);
      expect(restored, isA<TimerPaused>());
      expect((restored as TimerPaused).elapsed, const Duration(seconds: 1));
    });

    test('AC2: restart po ukończonej sesji w tle przechodzi do idle', () async {
      final sessionStartedAt = now.subtract(const Duration(seconds: 5));
      final runningState = TimerState.running(
        session: PomodoroSession(
          id: 'seed',
          type: SessionType.work,
          duration: testSettings.workDuration,
          startedAt: sessionStartedAt,
        ),
        elapsed: const Duration(seconds: 1),
      );
      fakeRepo.seed(runningState, Duration.zero);

      final ticker2 = FakeTicker();
      addTearDown(ticker2.close);
      final service2 = _FakeForegroundService();
      final container2 = ProviderContainer(
        overrides: [
          tickerProvider.overrideWithValue(ticker2),
          clockProvider.overrideWithValue(() => now),
          timerSettingsProvider.overrideWith(
            () => _FixedTimerSettingsNotifier(testSettings),
          ),
          pomodoroForegroundServiceProvider.overrideWithValue(service2),
          timerStateRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container2.dispose);

      container2.read(timerControllerProvider);
      await pump();
      await pump();

      final restored = container2.read(timerControllerProvider);
      expect(restored, isA<TimerIdle>());
      expect((restored as TimerIdle).nextSessionType, SessionType.shortBreak);
    });
  });
}

class _FixedTimerSettingsNotifier extends TimerSettingsNotifier {
  _FixedTimerSettingsNotifier(this._initial);

  final TimerSettings _initial;

  @override
  TimerSettings build() => _initial;
}

class _FakeForegroundService implements PomodoroForegroundService {
  int starts = 0;
  int pauses = 0;
  int resumes = 0;
  int stops = 0;

  @override
  Future<void> configure() async {}

  @override
  Future<void> start({
    required SessionType type,
    required Duration total,
    required SessionDisplayLabels labels,
  }) async {
    starts++;
  }

  @override
  Future<void> pause({required Duration remaining}) async {
    pauses++;
  }

  @override
  Future<void> resume({required Duration remaining}) async {
    resumes++;
  }

  @override
  Future<void> stop() async {
    stops++;
  }

  @override
  Stream<ForegroundServiceAction> get actions => const Stream.empty();

  @override
  Future<void> dispose() async {}
}

class _FakeTimerStateRepository implements TimerStateRepository {
  ({TimerState state, Duration accumulatedPaused})? _saved;
  int saves = 0;

  void seed(TimerState state, Duration accumulatedPaused) {
    _saved = (state: state, accumulatedPaused: accumulatedPaused);
  }

  @override
  Future<void> save(TimerState state, Duration accumulatedPaused) async {
    saves++;
    if (state is TimerRunning || state is TimerPaused) {
      _saved = (state: state, accumulatedPaused: accumulatedPaused);
    } else {
      _saved = null;
    }
  }

  @override
  Future<({TimerState state, Duration accumulatedPaused})?> load() async =>
      _saved;
}
