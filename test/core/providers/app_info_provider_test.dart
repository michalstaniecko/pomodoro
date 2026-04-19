import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pomodoro/core/l10n/locale_keys.g.dart';
import 'package:pomodoro/core/providers/app_info_provider.dart';

void main() {
  test('appInfoProvider exposes home app info key', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(appInfoProvider), LocaleKeys.home_app_info);
  });
}
