import 'package:freezed_annotation/freezed_annotation.dart';

part 'pomodoro_cycle.freezed.dart';

@freezed
class PomodoroCycle with _$PomodoroCycle {
  const PomodoroCycle._();

  @Assert(
    'sessionsBeforeLongBreak >= 1',
    'sessionsBeforeLongBreak must be >= 1',
  )
  @Assert('completedWorkSessions >= 0', 'completedWorkSessions must be >= 0')
  const factory PomodoroCycle({
    @Default(4) int sessionsBeforeLongBreak,
    @Default(0) int completedWorkSessions,
  }) = _PomodoroCycle;
}
