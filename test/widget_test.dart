import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fishdorro/app/app.dart';

void main() {
  testWidgets('FishdorroApp renders placeholder home', (tester) async {
    await tester.pumpWidget(const FishdorroApp());

    expect(find.text('Fishdorro — M0 scaffold'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
