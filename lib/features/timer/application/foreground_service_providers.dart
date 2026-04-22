import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/android_foreground_service.dart';
import '../data/ios_live_activity_service.dart';
import '../data/noop_foreground_service.dart';
import '../data/pomodoro_foreground_service.dart';
import '../data/timer_state_repository.dart';

final pomodoroForegroundServiceProvider = Provider<PomodoroForegroundService>((
  ref,
) {
  final PomodoroForegroundService service;
  if (defaultTargetPlatform == TargetPlatform.android) {
    service = AndroidForegroundService();
  } else if (!kIsWeb && Platform.isIOS) {
    service = IosLiveActivityService();
  } else {
    service = const NoopPomodoroForegroundService();
  }
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
});

final foregroundServiceActionsProvider =
    StreamProvider<ForegroundServiceAction>(
      (ref) => ref.watch(pomodoroForegroundServiceProvider).actions,
    );

final timerStateRepositoryProvider = Provider<TimerStateRepository>(
  (ref) => TimerStateRepository(),
);
