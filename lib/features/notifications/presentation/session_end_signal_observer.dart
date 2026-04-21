import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../timer/application/session_finished_event.dart';
import '../../timer/application/timer_controller.dart';
import '../../timer/application/timer_settings.dart';
import '../application/notifications_providers.dart';

class SessionEndSignalObserver extends ConsumerWidget {
  const SessionEndSignalObserver({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<SessionFinishedEvent>>(
      sessionFinishedEventsProvider,
      (previous, next) {
        next.whenData((_) {
          final TimerSettings settings = ref.read(timerSettingsProvider);
          unawaited(
            ref
                .read(sessionNotifierProvider)
                .signalSessionEnd(
                  sound: settings.soundEnabled,
                  vibrate: settings.vibrationEnabled,
                ),
          );
        });
      },
    );
    return child;
  }
}
