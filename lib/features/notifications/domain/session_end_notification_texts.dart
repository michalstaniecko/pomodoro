import 'package:flutter/foundation.dart';

@immutable
class SessionEndNotificationTexts {
  const SessionEndNotificationTexts({
    required this.title,
    required this.body,
    required this.startNextActionLabel,
    required this.viewActionLabel,
  });

  final String title;
  final String body;
  final String startNextActionLabel;
  final String viewActionLabel;
}
