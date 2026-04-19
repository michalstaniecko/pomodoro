import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/locale_keys.g.dart';
import '../../../core/providers/app_info_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfoKey = ref.watch(appInfoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro')),
      body: Center(child: Text(appInfoKey.tr())),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/settings'),
        tooltip: LocaleKeys.settings_tooltip.tr(),
        child: const Icon(Icons.settings),
      ),
    );
  }
}
