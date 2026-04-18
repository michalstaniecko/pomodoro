import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fishdorro/app/app.dart';

void main() {
  testWidgets('FishdorroApp renders home route with placeholder text', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: FishdorroApp()));
    await tester.pumpAndSettle();

    expect(find.text('Fishdorro — M0 scaffold'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
