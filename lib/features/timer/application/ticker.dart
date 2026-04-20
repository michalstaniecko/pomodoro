import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Ticker {
  Stream<void> tick({required Duration interval});
}

class SystemTicker implements Ticker {
  const SystemTicker();

  @override
  Stream<void> tick({required Duration interval}) =>
      Stream<void>.periodic(interval, (_) {});
}

final tickerProvider = Provider<Ticker>((ref) => const SystemTicker());
