import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro/core/providers/app_info_provider.dart';

void main() {
  test('appInfoProvider exposes scaffold label', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(appInfoProvider), 'Pomodoro — M0 scaffold');
  });
}
