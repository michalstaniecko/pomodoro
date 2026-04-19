import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro/app/app.dart';

void main() {
  testWidgets('router starts at / and navigates to /settings', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PomodoroApp()));
    await tester.pumpAndSettle();

    expect(find.text('Pomodoro — M0 scaffold'), findsOneWidget);
    expect(find.text('Settings — placeholder'), findsNothing);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings — placeholder'), findsOneWidget);
    expect(find.text('Pomodoro — M0 scaffold'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Pomodoro — M0 scaffold'), findsOneWidget);
  });
}
