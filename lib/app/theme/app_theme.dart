import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  // placeholder, do ustalenia w issue brand „Pomodoro by Small Fish"
  static const Color _seedColor = Colors.teal;

  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
    useMaterial3: true,
  );

  static ThemeData get dark => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
