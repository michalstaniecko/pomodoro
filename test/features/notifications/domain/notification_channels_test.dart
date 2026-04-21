import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro/features/notifications/domain/notification_channels.dart';

void main() {
  group('NotificationChannels', () {
    test('session channel ma stabilne id i nazwę', () {
      expect(NotificationChannels.sessionChannelId, 'pomodoro_session');
      expect(NotificationChannels.sessionChannelName, 'Pomodoro Session');
    });

    test('end channel ma stabilne id i nazwę', () {
      expect(NotificationChannels.endChannelId, 'pomodoro_end');
      expect(NotificationChannels.endChannelName, 'Pomodoro End');
    });

    test('id kanałów są unikalne', () {
      expect(
        NotificationChannels.sessionChannelId,
        isNot(NotificationChannels.endChannelId),
      );
    });
  });
}
