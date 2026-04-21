import '../domain/session_display_labels.dart';
import '../domain/session_type.dart';
import 'pomodoro_foreground_service.dart';

class NoopPomodoroForegroundService implements PomodoroForegroundService {
  const NoopPomodoroForegroundService();

  @override
  Future<void> configure() async {}

  @override
  Future<void> start({
    required SessionType type,
    required Duration total,
    required SessionDisplayLabels labels,
  }) async {}

  @override
  Future<void> pause({required Duration remaining}) async {}

  @override
  Future<void> resume({required Duration remaining}) async {}

  @override
  Future<void> stop() async {}

  @override
  Stream<ForegroundServiceAction> get actions => const Stream.empty();

  @override
  Future<void> dispose() async {}
}
