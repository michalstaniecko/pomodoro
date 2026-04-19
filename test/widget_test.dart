import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro/app/app.dart';

void main() {
  testWidgets('PomodoroApp renders home route with placeholder text', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: PomodoroApp()));
    await tester.pumpAndSettle();

    expect(find.text('Pomodoro — M0 scaffold'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
