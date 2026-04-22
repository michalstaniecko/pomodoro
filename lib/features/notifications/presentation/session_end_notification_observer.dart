import 'dart:async';
import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_keys.g.dart';
import '../../timer/application/session_finished_event.dart';
import '../../timer/application/timer_controller.dart';
import '../../timer/domain/session_type.dart';
import '../../timer/domain/timer_state.dart';
import '../application/notifications_providers.dart';
import '../domain/session_end_notification_texts.dart';

class SessionEndNotificationObserver extends ConsumerWidget {
  const SessionEndNotificationObserver({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Android: show end-notification po naturalnym zakończeniu sesji.
    ref.listen<AsyncValue<SessionFinishedEvent>>(
      sessionFinishedEventsProvider,
      (previous, next) {
        next.whenData((event) {
          if (!Platform.isAndroid) {
            return;
          }
          if (!event.session.completed) {
            return;
          }
          final SessionEndNotificationTexts texts = _buildTexts(
            context: context,
            completedType: event.session.type,
            nextType: event.nextType,
          );
          unawaited(
            ref
                .read(sessionEndNotificationServiceProvider)
                .showEndNotification(texts: texts),
          );
        });
      },
    );

    // iOS: scheduled fallback — reagujemy TYLKO na zmianę (stateType, sessionId),
    // ignorując zmiany elapsed. Bez tego select() `remaining` zmieniałoby się
    // co sekundę i wywoływało re-schedule co tick.
    ref.listen<({Type stateType, String? sessionId})>(
      timerControllerProvider.select(
        (s) => (
          stateType: s.runtimeType,
          sessionId: s is TimerRunning ? s.session.id : null,
        ),
      ),
      (previous, next) {
        if (!Platform.isIOS) {
          return;
        }
        final service = ref.read(sessionEndNotificationServiceProvider);
        if (next.stateType == TimerRunning) {
          // Start nowej sesji lub resume (zmiana sessionId lub powrót do
          // Running). Obliczamy stały punkt końca: startedAt + duration.
          final TimerState timerState = ref.read(timerControllerProvider);
          if (timerState is! TimerRunning) {
            return;
          }
          final DateTime endAt = timerState.session.startedAt.add(
            timerState.session.duration,
          );
          final SessionEndNotificationTexts texts = _buildTexts(
            context: context,
            completedType: timerState.session.type,
            nextType: _estimateNextType(timerState.session.type),
          );
          unawaited(
            service.scheduleEndNotification(endAt: endAt, texts: texts),
          );
        } else {
          // Pause / stop / skip / complete — anulujemy zaplanowaną notyfikację.
          unawaited(service.cancelScheduledEndNotification());
        }
      },
    );

    return child;
  }

  SessionEndNotificationTexts _buildTexts({
    required BuildContext context,
    required SessionType completedType,
    required SessionType nextType,
  }) {
    final String body = switch (completedType) {
      SessionType.work => LocaleKeys.notifications_end_body_work.tr(),
      SessionType.shortBreak =>
        LocaleKeys.notifications_end_body_short_break.tr(),
      SessionType.longBreak =>
        LocaleKeys.notifications_end_body_long_break.tr(),
    };
    final String startNextLabel = nextType == SessionType.work
        ? LocaleKeys.notifications_end_action_start_work.tr()
        : LocaleKeys.notifications_end_action_start_break.tr();
    return SessionEndNotificationTexts(
      title: LocaleKeys.notifications_end_title.tr(),
      body: body,
      startNextActionLabel: startNextLabel,
      viewActionLabel: LocaleKeys.notifications_end_action_view.tr(),
    );
  }

  // Uproszczone: work → break, break → work. Używane tylko na iOS dla etykiety
  // CTA — nie rozróżnia short/long break, bo „Zacznij przerwę" pasuje do obu.
  SessionType _estimateNextType(SessionType completedType) {
    return switch (completedType) {
      SessionType.work => SessionType.shortBreak,
      SessionType.shortBreak || SessionType.longBreak => SessionType.work,
    };
  }
}
