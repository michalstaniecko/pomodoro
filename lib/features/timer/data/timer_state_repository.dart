import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/timer_state.dart';

/// Persystuje aktywną sesję (TimerRunning/TimerPaused) w SharedPreferences,
/// aby odtworzyć ją po restarcie aplikacji. Dla stanów Idle/Finished klucz
/// jest czyszczony, co gwarantuje brak "martwych" sesji przy kolejnym starcie.
class TimerStateRepository {
  TimerStateRepository();

  static const String activeSessionKey = 'pomodoro.timer.activeSession';

  Future<void> save(TimerState state, Duration accumulatedPaused) async {
    final prefs = await SharedPreferences.getInstance();
    if (state is TimerRunning || state is TimerPaused) {
      final payload = <String, dynamic>{
        'state': state.toJson(),
        'accumulatedPausedMs': accumulatedPaused.inMilliseconds,
      };
      await prefs.setString(activeSessionKey, jsonEncode(payload));
    } else {
      await prefs.remove(activeSessionKey);
    }
  }

  Future<({TimerState state, Duration accumulatedPaused})?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(activeSessionKey);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final state = TimerState.fromJson(
        (map['state'] as Map).cast<String, dynamic>(),
      );
      final accumulatedMs = (map['accumulatedPausedMs'] as num?)?.toInt() ?? 0;
      if (state is! TimerRunning && state is! TimerPaused) {
        await prefs.remove(activeSessionKey);
        return null;
      }
      return (
        state: state,
        accumulatedPaused: Duration(milliseconds: accumulatedMs),
      );
    } catch (_) {
      await prefs.remove(activeSessionKey);
      return null;
    }
  }
}
