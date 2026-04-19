import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('router starts at / and navigates to /settings', (tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('pl'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('pl'),
        startLocale: const Locale('pl'),
        child: const ProviderScope(child: PomodoroApp()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pomodoro — szkielet M0'), findsOneWidget);
    expect(find.text('Ustawienia — placeholder'), findsNothing);

    await tester.tap(find.byTooltip('Ustawienia'));
    await tester.pumpAndSettle();

    expect(find.text('Ustawienia — placeholder'), findsOneWidget);
    expect(find.text('Pomodoro — szkielet M0'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Pomodoro — szkielet M0'), findsOneWidget);
  });
}
