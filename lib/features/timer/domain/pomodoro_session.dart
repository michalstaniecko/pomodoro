import 'package:freezed_annotation/freezed_annotation.dart';

import 'duration_converter.dart';
import 'session_type.dart';

part 'pomodoro_session.freezed.dart';
part 'pomodoro_session.g.dart';

@freezed
class PomodoroSession with _$PomodoroSession {
  const factory PomodoroSession({
    required String id,
    required SessionType type,
    @DurationMillisecondsConverter() required Duration duration,
    required DateTime startedAt,
    DateTime? completedAt,
    @Default(false) bool completed,
  }) = _PomodoroSession;

  factory PomodoroSession.fromJson(Map<String, dynamic> json) =>
      _$PomodoroSessionFromJson(json);
}
