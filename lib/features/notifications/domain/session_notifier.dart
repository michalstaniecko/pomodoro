abstract class SessionNotifier {
  Future<void> signalSessionEnd({required bool sound, required bool vibrate});

  Future<void> dispose();
}
