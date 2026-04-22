import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/timer_controller.dart';

/// Wywołuje `TimerController.onAppResumed()` przy powrocie appki do foreground,
/// co pozwala dogonić elapsed po zawieszeniu Dart isolate'u (iOS lock screen,
/// Android doze mode).
class TimerLifecycleObserver extends ConsumerStatefulWidget {
  const TimerLifecycleObserver({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<TimerLifecycleObserver> createState() =>
      _TimerLifecycleObserverState();
}

class _TimerLifecycleObserverState extends ConsumerState<TimerLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(timerControllerProvider.notifier).onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
