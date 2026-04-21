import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/foreground_service_providers.dart';
import '../application/timer_controller.dart';
import '../data/pomodoro_foreground_service.dart';
import '../domain/timer_state.dart';

class ForegroundServiceActionObserver extends ConsumerWidget {
  const ForegroundServiceActionObserver({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<ForegroundServiceAction>>(
      foregroundServiceActionsProvider,
      (previous, next) {
        next.whenData((action) {
          final controller = ref.read(timerControllerProvider.notifier);
          final state = ref.read(timerControllerProvider);
          switch (action) {
            case ForegroundServiceAction.pause:
              if (state is TimerRunning) {
                controller.pause();
              }
            case ForegroundServiceAction.resume:
              if (state is TimerPaused) {
                controller.resume();
              }
            case ForegroundServiceAction.stop:
              if (state is TimerRunning || state is TimerPaused) {
                controller.stop();
              }
          }
        });
      },
    );
    return child;
  }
}
