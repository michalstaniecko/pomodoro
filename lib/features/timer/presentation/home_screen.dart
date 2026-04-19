import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_info_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfo = ref.watch(appInfoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro')),
      body: Center(child: Text(appInfo)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/settings'),
        tooltip: 'Settings',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
