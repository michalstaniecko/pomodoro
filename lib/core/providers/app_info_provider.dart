import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/locale_keys.g.dart';

final appInfoProvider = Provider<String>((ref) => LocaleKeys.home_app_info);
