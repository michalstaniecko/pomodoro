import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/audio_vibration_session_notifier.dart';
import '../domain/session_notifier.dart';

final sessionNotifierProvider = Provider<SessionNotifier>((ref) {
  final SessionNotifier notifier = AudioVibrationSessionNotifier();
  ref.onDispose(() {
    unawaited(notifier.dispose());
  });
  return notifier;
});
