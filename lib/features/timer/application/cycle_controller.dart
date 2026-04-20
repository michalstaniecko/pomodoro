import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/pomodoro_cycle.dart';
import 'timer_settings.dart';

/// Reaktywny holder stanu cyklu Pomodoro (liczba ukończonych sesji pracy
/// oraz próg długiej przerwy). Wyodrębniony z [TimerController], żeby UI
/// mógł obserwować cykl bez rozszerzania [TimerState] i regeneracji Freezed.
class CycleController extends Notifier<PomodoroCycle> {
  @override
  PomodoroCycle build() {
    final settings = ref.watch(timerSettingsProvider);
    return PomodoroCycle(
      sessionsBeforeLongBreak: settings.sessionsBeforeLongBreak,
    );
  }

  void set(PomodoroCycle cycle) {
    state = cycle;
  }
}

final cycleControllerProvider =
    NotifierProvider<CycleController, PomodoroCycle>(CycleController.new);
