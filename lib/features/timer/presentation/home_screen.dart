import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/locale_keys.g.dart';
import '../application/cycle_controller.dart';
import '../application/timer_controller.dart';
import '../application/timer_settings.dart';
import '../domain/session_type.dart';
import '../domain/timer_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerControllerProvider);
    final cycle = ref.watch(cycleControllerProvider);
    final settings = ref.watch(timerSettingsProvider);

    final sessionType = _sessionTypeOf(timerState);
    final total = _totalDurationOf(timerState, settings, sessionType);
    final elapsed = _elapsedOf(timerState);
    final remaining = _clampNonNegative(total - elapsed);
    final progress = total.inMilliseconds == 0
        ? 0.0
        : (elapsed.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 600;
            final widthBased = isCompact ? constraints.maxWidth * 0.7 : 360.0;
            final heightBased = constraints.maxHeight * 0.55;
            final dialSize = math.max(160.0, math.min(widthBased, heightBased));
            final countdownStyle = Theme.of(context).textTheme.displayLarge
                ?.copyWith(
                  fontSize: isCompact ? 56 : 88,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.w300,
                );

            final hPad = isCompact ? 16.0 : 32.0;
            final vPad = isCompact ? 16.0 : 24.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 2 * vPad,
                  minWidth: constraints.maxWidth - 2 * hPad,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _sessionTypeLabel(sessionType).tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: dialSize,
                      height: dialSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: progress,
                                end: progress,
                              ),
                              duration: const Duration(milliseconds: 300),
                              builder: (context, value, _) =>
                                  CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: isCompact ? 8 : 12,
                                  ),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              _formatCountdown(remaining),
                              key: ValueKey<String>(
                                _formatCountdown(remaining),
                              ),
                              textAlign: TextAlign.center,
                              style: countdownStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      LocaleKeys.timer_cycle_progress.tr(
                        namedArgs: {
                          'current':
                              '${cycle.completedWorkSessions % cycle.sessionsBeforeLongBreak}',
                          'total': '${cycle.sessionsBeforeLongBreak}',
                        },
                      ),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    _TimerActions(state: timerState),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/settings'),
        tooltip: LocaleKeys.settings_tooltip.tr(),
        child: const Icon(Icons.settings),
      ),
    );
  }

  SessionType _sessionTypeOf(TimerState state) => switch (state) {
    TimerIdle(:final nextSessionType) => nextSessionType,
    TimerRunning(:final session) => session.type,
    TimerPaused(:final session) => session.type,
    TimerFinished(:final session) => session.type,
  };

  Duration _totalDurationOf(
    TimerState state,
    TimerSettings settings,
    SessionType type,
  ) => switch (state) {
    TimerIdle() => settings.durationFor(type),
    TimerRunning(:final session) => session.duration,
    TimerPaused(:final session) => session.duration,
    TimerFinished(:final session) => session.duration,
  };

  Duration _elapsedOf(TimerState state) => switch (state) {
    TimerIdle() => Duration.zero,
    TimerRunning(:final elapsed) => elapsed,
    TimerPaused(:final elapsed) => elapsed,
    TimerFinished(:final session) => session.duration,
  };

  Duration _clampNonNegative(Duration d) => d.isNegative ? Duration.zero : d;

  String _sessionTypeLabel(SessionType type) => switch (type) {
    SessionType.work => LocaleKeys.timer_session_type_work,
    SessionType.shortBreak => LocaleKeys.timer_session_type_short_break,
    SessionType.longBreak => LocaleKeys.timer_session_type_long_break,
  };

  String _formatCountdown(Duration d) {
    final totalSeconds = d.inSeconds;
    final mm = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final ss = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}

class _TimerActions extends ConsumerWidget {
  const _TimerActions({required this.state});

  final TimerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(timerControllerProvider.notifier);

    final buttons = switch (state) {
      TimerIdle() => <Widget>[
        FilledButton.icon(
          onPressed: controller.start,
          icon: const Icon(Icons.play_arrow),
          label: Text(LocaleKeys.timer_actions_start.tr()),
        ),
      ],
      TimerRunning() => <Widget>[
        FilledButton.icon(
          onPressed: controller.pause,
          icon: const Icon(Icons.pause),
          label: Text(LocaleKeys.timer_actions_pause.tr()),
        ),
        OutlinedButton.icon(
          onPressed: controller.stop,
          icon: const Icon(Icons.stop),
          label: Text(LocaleKeys.timer_actions_stop.tr()),
        ),
        OutlinedButton.icon(
          onPressed: controller.skip,
          icon: const Icon(Icons.skip_next),
          label: Text(LocaleKeys.timer_actions_skip.tr()),
        ),
      ],
      TimerPaused() => <Widget>[
        FilledButton.icon(
          onPressed: controller.resume,
          icon: const Icon(Icons.play_arrow),
          label: Text(LocaleKeys.timer_actions_resume.tr()),
        ),
        OutlinedButton.icon(
          onPressed: controller.stop,
          icon: const Icon(Icons.stop),
          label: Text(LocaleKeys.timer_actions_stop.tr()),
        ),
        OutlinedButton.icon(
          onPressed: controller.skip,
          icon: const Icon(Icons.skip_next),
          label: Text(LocaleKeys.timer_actions_skip.tr()),
        ),
      ],
      // Finished to przelotny stan — controller natychmiast wraca do Idle.
      TimerFinished() => const <Widget>[],
    };

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: buttons,
    );
  }
}
