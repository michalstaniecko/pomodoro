import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/locale_keys.g.dart';
import '../../timer/application/timer_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(timerSettingsProvider);
    final notifier = ref.read(timerSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_title.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        children: [
          _Section(
            title: LocaleKeys.settings_section_durations.tr(),
            children: [
              _MinutesSlider(
                label: LocaleKeys.settings_work_duration.tr(),
                minutes: settings.workDuration.inMinutes,
                min: TimerSettings.workMinMinutes,
                max: TimerSettings.workMaxMinutes,
                onChanged: notifier.setWorkMinutes,
              ),
              _MinutesSlider(
                label: LocaleKeys.settings_short_break_duration.tr(),
                minutes: settings.shortBreakDuration.inMinutes,
                min: TimerSettings.shortBreakMinMinutes,
                max: TimerSettings.shortBreakMaxMinutes,
                onChanged: notifier.setShortBreakMinutes,
              ),
              _MinutesSlider(
                label: LocaleKeys.settings_long_break_duration.tr(),
                minutes: settings.longBreakDuration.inMinutes,
                min: TimerSettings.longBreakMinMinutes,
                max: TimerSettings.longBreakMaxMinutes,
                onChanged: notifier.setLongBreakMinutes,
              ),
            ],
          ),
          _Section(
            title: LocaleKeys.settings_section_cycle.tr(),
            children: [
              _SessionsSlider(
                label: LocaleKeys.settings_sessions_before_long_break.tr(),
                value: settings.sessionsBeforeLongBreak,
                min: TimerSettings.sessionsMin,
                max: TimerSettings.sessionsMax,
                onChanged: notifier.setSessionsBeforeLongBreak,
              ),
            ],
          ),
          _Section(
            title: LocaleKeys.settings_section_automation.tr(),
            children: [
              SwitchListTile(
                title: Text(LocaleKeys.settings_auto_start_breaks.tr()),
                value: settings.autoStartBreaks,
                onChanged: notifier.setAutoStartBreaks,
              ),
              SwitchListTile(
                title: Text(LocaleKeys.settings_auto_start_next_work.tr()),
                value: settings.autoStartNextWork,
                onChanged: notifier.setAutoStartNextWork,
              ),
            ],
          ),
          _Section(
            title: LocaleKeys.settings_section_notifications.tr(),
            children: [
              SwitchListTile(
                title: Text(LocaleKeys.settings_sound.tr()),
                value: settings.soundEnabled,
                onChanged: notifier.setSoundEnabled,
              ),
              SwitchListTile(
                title: Text(LocaleKeys.settings_vibration.tr()),
                value: settings.vibrationEnabled,
                onChanged: notifier.setVibrationEnabled,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _MinutesSlider extends StatelessWidget {
  const _MinutesSlider({
    required this.label,
    required this.minutes,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int minutes;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                LocaleKeys.settings_minutes_value.tr(
                  namedArgs: {'count': '$minutes'},
                ),
              ),
            ],
          ),
          Slider(
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            value: minutes.toDouble().clamp(min.toDouble(), max.toDouble()),
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}

class _SessionsSlider extends StatelessWidget {
  const _SessionsSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                LocaleKeys.settings_sessions_value.tr(
                  namedArgs: {'count': '$value'},
                ),
              ),
            ],
          ),
          Slider(
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            value: value.toDouble().clamp(min.toDouble(), max.toDouble()),
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}
