import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app/app.dart';
import 'features/notifications/application/notifications_providers.dart';
import 'features/notifications/data/local_notifications_initializer.dart';
import 'features/timer/application/foreground_service_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Timezone database musi być załadowana przed pierwszym zonedSchedule (iOS).
  tz.initializeTimeZones();

  // Inicjalizacja pluginu notyfikacji przed runApp — tworzy kanały Android
  // i prosi o uprawnienia runtime. Wymóg AC issue #16.
  final FlutterLocalNotificationsPlugin plugin =
      await const LocalNotificationsInitializer().initialize();

  final container = ProviderContainer(
    overrides: <Override>[
      flutterLocalNotificationsPluginProvider.overrideWithValue(plugin),
    ],
  );
  await container.read(pomodoroForegroundServiceProvider).configure();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('pl'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('pl'),
      startLocale: const Locale('pl'),
      child: UncontrolledProviderScope(
        container: container,
        child: const PomodoroApp(),
      ),
    ),
  );
}
