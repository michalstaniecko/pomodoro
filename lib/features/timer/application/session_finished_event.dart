import 'package:flutter/foundation.dart';

import '../domain/pomodoro_session.dart';
import '../domain/session_type.dart';

@immutable
class SessionFinishedEvent {
  const SessionFinishedEvent({
    required this.session,
    required this.finishedAt,
    required this.nextType,
  });

  final PomodoroSession session;
  final DateTime finishedAt;
  final SessionType nextType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionFinishedEvent &&
          runtimeType == other.runtimeType &&
          session == other.session &&
          finishedAt == other.finishedAt &&
          nextType == other.nextType;

  @override
  int get hashCode => Object.hash(session, finishedAt, nextType);
}
