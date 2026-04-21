import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import '../domain/session_notifier.dart';

class AudioVibrationSessionNotifier implements SessionNotifier {
  AudioVibrationSessionNotifier({AudioPlayer? player})
    : _player = player ?? AudioPlayer() {
    // Kategoria alarm/playback pozwala odtworzyć krótki sygnał także gdy
    // telefon jest wyciszony lub ekran zablokowany (dopóki proces aplikacji
    // żyje). Pełne granie po zabiciu procesu wymaga foreground service
    // i jest poza zakresem tego issue.
    _player.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.alarm,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: const <AVAudioSessionOptions>{
            AVAudioSessionOptions.mixWithOthers,
          },
        ),
      ),
    );
    _player.setReleaseMode(ReleaseMode.stop);
  }

  static const String _bellAsset = 'sounds/bell.wav';
  static const Duration _vibrationDuration = Duration(milliseconds: 500);

  final AudioPlayer _player;

  @override
  Future<void> signalSessionEnd({
    required bool sound,
    required bool vibrate,
  }) async {
    final List<Future<void>> jobs = <Future<void>>[];
    if (sound) {
      jobs.add(_playBell());
    }
    if (vibrate) {
      jobs.add(_vibrate());
    }
    if (jobs.isEmpty) {
      return;
    }
    await Future.wait(jobs);
  }

  Future<void> _playBell() async {
    try {
      await _player.stop();
      await _player.play(AssetSource(_bellAsset));
    } catch (_) {
      // Best-effort: ignorujemy błędy odtwarzania (np. brak wyjścia audio).
    }
  }

  Future<void> _vibrate() async {
    try {
      final bool hasVibrator = await Vibration.hasVibrator();
      if (!hasVibrator) {
        return;
      }
      await Vibration.vibrate(duration: _vibrationDuration.inMilliseconds);
    } catch (_) {
      // Best-effort (np. emulator bez wibratora).
    }
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }
}
