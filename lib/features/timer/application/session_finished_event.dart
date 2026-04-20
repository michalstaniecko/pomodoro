import 'package:flutter/foundation.dart';

import '../domain/pomodoro_session.dart';

@immutable
class SessionFinishedEvent {
  const SessionFinishedEvent({required this.session, required this.finishedAt});

  final PomodoroSession session;
  final DateTime finishedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionFinishedEvent &&
          runtimeType == other.runtimeType &&
          session == other.session &&
          finishedAt == other.finishedAt;

  @override
  int get hashCode => Object.hash(session, finishedAt);
}
