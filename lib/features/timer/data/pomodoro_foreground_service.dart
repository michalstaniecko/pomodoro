import '../domain/session_display_labels.dart';
import '../domain/session_type.dart';

enum ForegroundServiceAction { pause, resume, stop }

abstract class PomodoroForegroundService {
  Future<void> configure();

  Future<void> start({
    required SessionType type,
    required Duration total,
    required SessionDisplayLabels labels,
  });

  Future<void> pause({required Duration remaining});

  Future<void> resume({required Duration remaining});

  Future<void> stop();

  Stream<ForegroundServiceAction> get actions;

  Future<void> dispose();
}
