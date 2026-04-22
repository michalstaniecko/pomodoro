import 'dart:async';

import 'package:live_activities/live_activities.dart';

import '../domain/session_display_labels.dart';
import '../domain/session_type.dart';
import 'pomodoro_foreground_service.dart';

const String _appGroupId = 'group.com.smallfishbusiness.pomodoro';

class IosLiveActivityService implements PomodoroForegroundService {
  IosLiveActivityService({LiveActivities? plugin})
    : _plugin = plugin ?? LiveActivities();

  final LiveActivities _plugin;
  String? _activityId;
  SessionType _lastType = SessionType.work;

  @override
  Future<void> configure() async {
    await _plugin.init(appGroupId: _appGroupId);
  }

  @override
  Future<void> start({
    required SessionType type,
    required Duration total,
    required SessionDisplayLabels labels,
  }) async {
    await _endIfRunning();
    _lastType = type;
    _activityId = await _plugin.createActivity(
      'pomodoro_session',
      _buildData(type: type, remaining: total, isPaused: false),
    );
  }

  @override
  Future<void> pause({required Duration remaining}) async {
    final id = _activityId;
    if (id == null) return;
    await _plugin.updateActivity(
      id,
      _buildData(type: _lastType, remaining: remaining, isPaused: true),
    );
  }

  @override
  Future<void> resume({required Duration remaining}) async {
    final id = _activityId;
    if (id == null) return;
    await _plugin.updateActivity(
      id,
      _buildData(type: _lastType, remaining: remaining, isPaused: false),
    );
  }

  @override
  Future<void> stop() async {
    await _endIfRunning();
  }

  @override
  Stream<ForegroundServiceAction> get actions => const Stream.empty();

  @override
  Future<void> dispose() async {
    await _endIfRunning();
  }

  Future<void> _endIfRunning() async {
    final id = _activityId;
    if (id == null) return;
    await _plugin.endActivity(id);
    _activityId = null;
  }

  Map<String, dynamic> _buildData({
    required SessionType type,
    required Duration remaining,
    required bool isPaused,
  }) {
    _lastType = type;
    final endTime = DateTime.now().add(remaining);
    return <String, dynamic>{
      'sessionType': _encodeType(type),
      'endTime': endTime.millisecondsSinceEpoch,
      'isPaused': isPaused,
      'remainingSeconds': remaining.inSeconds,
    };
  }

  String _encodeType(SessionType type) {
    switch (type) {
      case SessionType.work:
        return 'work';
      case SessionType.shortBreak:
        return 'shortBreak';
      case SessionType.longBreak:
        return 'longBreak';
    }
  }
}
