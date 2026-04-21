import 'package:flutter/foundation.dart';

import 'session_type.dart';

@immutable
class SessionDisplayLabels {
  const SessionDisplayLabels({
    required this.work,
    required this.shortBreak,
    required this.longBreak,
    required this.pause,
    required this.resume,
    required this.stop,
  });

  final String work;
  final String shortBreak;
  final String longBreak;
  final String pause;
  final String resume;
  final String stop;

  String labelFor(SessionType type) {
    switch (type) {
      case SessionType.work:
        return work;
      case SessionType.shortBreak:
        return shortBreak;
      case SessionType.longBreak:
        return longBreak;
    }
  }
}
