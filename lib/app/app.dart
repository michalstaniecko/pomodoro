import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/router_provider.dart';
import '../features/notifications/presentation/session_end_signal_observer.dart';
import '../features/timer/presentation/foreground_service_action_observer.dart';
import '../features/timer/presentation/timer_lifecycle_observer.dart';
import 'theme/app_theme.dart';

class PomodoroApp extends ConsumerWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return TimerLifecycleObserver(
      child: SessionEndSignalObserver(
        child: ForegroundServiceActionObserver(
          child: MaterialApp.router(
            title: 'Pomodoro',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
