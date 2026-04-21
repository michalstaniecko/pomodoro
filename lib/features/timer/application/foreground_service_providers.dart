import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/android_foreground_service.dart';
import '../data/noop_foreground_service.dart';
import '../data/pomodoro_foreground_service.dart';

final pomodoroForegroundServiceProvider = Provider<PomodoroForegroundService>((
  ref,
) {
  final service = defaultTargetPlatform == TargetPlatform.android
      ? AndroidForegroundService()
      : const NoopPomodoroForegroundService();
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
});

final foregroundServiceActionsProvider =
    StreamProvider<ForegroundServiceAction>(
      (ref) => ref.watch(pomodoroForegroundServiceProvider).actions,
    );
