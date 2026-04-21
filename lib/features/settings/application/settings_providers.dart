import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/shared_preferences_settings_repository.dart';
import '../domain/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SharedPreferencesSettingsRepository(),
);
