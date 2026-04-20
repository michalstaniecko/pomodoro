import 'package:freezed_annotation/freezed_annotation.dart';

import 'duration_converter.dart';
import 'pomodoro_session.dart';
import 'session_type.dart';

part 'timer_state.freezed.dart';
part 'timer_state.g.dart';

@freezed
sealed class TimerState with _$TimerState {
  const factory TimerState.idle({
    @Default(SessionType.work) SessionType nextSessionType,
  }) = TimerIdle;

  const factory TimerState.running({
    required PomodoroSession session,
    @DurationMillisecondsConverter() @Default(Duration.zero) Duration elapsed,
  }) = TimerRunning;

  const factory TimerState.paused({
    required PomodoroSession session,
    @DurationMillisecondsConverter() required Duration elapsed,
  }) = TimerPaused;

  const factory TimerState.finished({required PomodoroSession session}) =
      TimerFinished;

  factory TimerState.fromJson(Map<String, dynamic> json) =>
      _$TimerStateFromJson(json);
}
