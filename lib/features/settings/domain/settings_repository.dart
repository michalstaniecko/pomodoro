import '../../timer/application/timer_settings.dart';

abstract class SettingsRepository {
  Future<TimerSettings> load();
  Future<void> save(TimerSettings settings);
}
