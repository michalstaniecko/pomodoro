import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../notifications/domain/notification_channels.dart';
import '../domain/session_display_labels.dart';
import '../domain/session_type.dart';
import 'pomodoro_foreground_service.dart';

const int _foregroundNotificationId = 1001;
const String _actionPauseId = 'pomodoro_action_pause';
const String _actionResumeId = 'pomodoro_action_resume';
const String _actionStopId = 'pomodoro_action_stop';
const String _openTimerPayload = 'open_timer';

class AndroidForegroundService implements PomodoroForegroundService {
  AndroidForegroundService({FlutterBackgroundService? service})
    : _service = service ?? FlutterBackgroundService();

  final FlutterBackgroundService _service;
  final StreamController<ForegroundServiceAction> _actions =
      StreamController<ForegroundServiceAction>.broadcast();
  StreamSubscription<Map<String, dynamic>?>? _actionSub;

  @override
  Future<void> configure() async {
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onServiceStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: NotificationChannels.sessionChannelId,
        initialNotificationTitle: 'Pomodoro',
        initialNotificationContent: '—',
        foregroundServiceNotificationId: _foregroundNotificationId,
        foregroundServiceTypes: [AndroidForegroundType.dataSync],
      ),
      iosConfiguration: IosConfiguration(autoStart: false),
    );

    _actionSub ??= _service.on('action').listen((event) {
      if (event == null) {
        return;
      }
      final raw = event['action'];
      if (raw is! String) {
        return;
      }
      switch (raw) {
        case 'pause':
          _actions.add(ForegroundServiceAction.pause);
        case 'resume':
          _actions.add(ForegroundServiceAction.resume);
        case 'stop':
          _actions.add(ForegroundServiceAction.stop);
      }
    });
  }

  @override
  Future<void> start({
    required SessionType type,
    required Duration total,
    required SessionDisplayLabels labels,
  }) async {
    final running = await _service.isRunning();
    if (!running) {
      await _service.startService();
    }
    _service.invoke('configure', {
      'sessionLabel': labels.labelFor(type),
      'pauseLabel': labels.pause,
      'resumeLabel': labels.resume,
      'stopLabel': labels.stop,
      'totalMs': total.inMilliseconds,
      'remainingMs': total.inMilliseconds,
      'paused': false,
    });
  }

  @override
  Future<void> pause({required Duration remaining}) async {
    _service.invoke('pause', {'remainingMs': remaining.inMilliseconds});
  }

  @override
  Future<void> resume({required Duration remaining}) async {
    _service.invoke('resume', {'remainingMs': remaining.inMilliseconds});
  }

  @override
  Future<void> stop() async {
    _service.invoke('stop');
  }

  @override
  Stream<ForegroundServiceAction> get actions => _actions.stream;

  @override
  Future<void> dispose() async {
    await _actionSub?.cancel();
    _actionSub = null;
    await _actions.close();
  }
}

@pragma('vm:entry-point')
void _onServiceStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  final plugin = FlutterLocalNotificationsPlugin();
  plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveBackgroundNotificationResponse: _onNotificationAction,
    onDidReceiveNotificationResponse: _onNotificationAction,
  );

  String sessionLabel = 'Pomodoro';
  String pauseLabel = 'Pause';
  String resumeLabel = 'Resume';
  String stopLabel = 'Stop';
  Duration remaining = Duration.zero;
  bool paused = false;
  Timer? ticker;

  String formatMmSs(Duration d) {
    final total = d.inSeconds < 0 ? 0 : d.inSeconds;
    final mm = (total ~/ 60).toString().padLeft(2, '0');
    final ss = (total % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Future<void> render() async {
    final title = sessionLabel;
    final content = formatMmSs(remaining);

    final details = AndroidNotificationDetails(
      NotificationChannels.sessionChannelId,
      NotificationChannels.sessionChannelName,
      channelDescription: NotificationChannels.sessionChannelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      showWhen: false,
      playSound: false,
      enableVibration: false,
      category: AndroidNotificationCategory.progress,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          paused ? _actionResumeId : _actionPauseId,
          paused ? resumeLabel : pauseLabel,
          showsUserInterface: false,
          cancelNotification: false,
        ),
        AndroidNotificationAction(
          _actionStopId,
          stopLabel,
          showsUserInterface: false,
          cancelNotification: false,
        ),
      ],
    );

    await plugin.show(
      _foregroundNotificationId,
      title,
      content,
      NotificationDetails(android: details),
      payload: _openTimerPayload,
    );

    if (service is AndroidServiceInstance) {
      unawaited(
        service.setForegroundNotificationInfo(title: title, content: content),
      );
    }
  }

  void startTicker() {
    ticker?.cancel();
    ticker = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (paused) {
        return;
      }
      remaining = remaining - const Duration(seconds: 1);
      if (remaining.isNegative) {
        remaining = Duration.zero;
      }
      await render();
      if (remaining == Duration.zero) {
        ticker?.cancel();
        ticker = null;
      }
    });
  }

  service.on('configure').listen((data) async {
    if (data == null) {
      return;
    }
    sessionLabel = (data['sessionLabel'] as String?) ?? sessionLabel;
    pauseLabel = (data['pauseLabel'] as String?) ?? pauseLabel;
    resumeLabel = (data['resumeLabel'] as String?) ?? resumeLabel;
    stopLabel = (data['stopLabel'] as String?) ?? stopLabel;
    final remainingMs = (data['remainingMs'] as num?)?.toInt();
    if (remainingMs != null) {
      remaining = Duration(milliseconds: remainingMs);
    }
    paused = (data['paused'] as bool?) ?? false;
    if (service is AndroidServiceInstance) {
      unawaited(service.setAsForegroundService());
    }
    await render();
    if (!paused) {
      startTicker();
    }
  });

  service.on('pause').listen((data) async {
    paused = true;
    final remainingMs = (data?['remainingMs'] as num?)?.toInt();
    if (remainingMs != null) {
      remaining = Duration(milliseconds: remainingMs);
    }
    ticker?.cancel();
    ticker = null;
    await render();
  });

  service.on('resume').listen((data) async {
    paused = false;
    final remainingMs = (data?['remainingMs'] as num?)?.toInt();
    if (remainingMs != null) {
      remaining = Duration(milliseconds: remainingMs);
    }
    await render();
    startTicker();
  });

  service.on('stop').listen((_) async {
    ticker?.cancel();
    ticker = null;
    await plugin.cancel(_foregroundNotificationId);
    await service.stopSelf();
  });

  service.on('action_pressed').listen((data) {
    final raw = data?['action'];
    if (raw is! String) {
      return;
    }
    service.invoke('action', {'action': raw});
    if (raw == 'pause') {
      paused = true;
      ticker?.cancel();
      ticker = null;
      unawaited(render());
    } else if (raw == 'resume') {
      paused = false;
      unawaited(render());
      startTicker();
    } else if (raw == 'stop') {
      ticker?.cancel();
      ticker = null;
      unawaited(plugin.cancel(_foregroundNotificationId));
      service.stopSelf();
    }
  });
}

@pragma('vm:entry-point')
void _onNotificationAction(NotificationResponse response) {
  final id = response.actionId;
  if (id == null) {
    return;
  }
  String? action;
  if (id == _actionPauseId) {
    action = 'pause';
  } else if (id == _actionResumeId) {
    action = 'resume';
  } else if (id == _actionStopId) {
    action = 'stop';
  }
  if (action == null) {
    return;
  }
  FlutterBackgroundService().invoke('action_pressed', {'action': action});
}
