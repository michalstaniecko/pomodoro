import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/app/app.dart';
import 'package:pomodoro/features/timer/application/foreground_service_providers.dart';
import 'package:pomodoro/features/timer/data/noop_foreground_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('PomodoroApp renders home route with timer UI', (tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('pl'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('pl'),
        startLocale: const Locale('pl'),
        child: ProviderScope(
          overrides: [
            pomodoroForegroundServiceProvider.overrideWithValue(
              const NoopPomodoroForegroundService(),
            ),
          ],
          child: const PomodoroApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    // Etykieta typu sesji — domyślnie „Praca".
    expect(find.text('Praca'), findsOneWidget);
    // Przycisk Start widoczny w stanie Idle.
    expect(find.text('Start'), findsOneWidget);
    // Countdown dla domyślnych 25 minut.
    expect(find.text('25:00'), findsOneWidget);
    // Progres cyklu 0/4.
    expect(find.text('0/4 sesji'), findsOneWidget);
  });
}
