import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fishdorro/core/providers/app_info_provider.dart';

void main() {
  test('appInfoProvider exposes scaffold label', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(appInfoProvider), 'Fishdorro — M0 scaffold');
  });
}
