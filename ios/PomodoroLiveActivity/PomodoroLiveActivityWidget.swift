import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct PomodoroLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodoroAttributes.self) { context in
            lockScreenView(state: context.state)
                .padding()
                .activityBackgroundTint(Color.black.opacity(0.6))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label(sessionTitle(context.state.sessionType), systemImage: icon(context.state.sessionType))
                        .font(.caption)
                        .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    countdown(state: context.state)
                        .font(.title2.monospacedDigit())
                        .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if context.state.isPaused {
                        Text("Paused")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }
            } compactLeading: {
                Image(systemName: icon(context.state.sessionType))
                    .foregroundColor(.white)
            } compactTrailing: {
                countdown(state: context.state)
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.white)
                    .frame(maxWidth: 48)
            } minimal: {
                Image(systemName: icon(context.state.sessionType))
                    .foregroundColor(.white)
            }
            .keylineTint(.red)
        }
    }

    @ViewBuilder
    private func lockScreenView(state: PomodoroAttributes.ContentState) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon(state.sessionType))
                .font(.title)
                .foregroundColor(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text(sessionTitle(state.sessionType))
                    .font(.headline)
                    .foregroundColor(.white)
                if state.isPaused {
                    Text("Paused")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }
            }
            Spacer()
            countdown(state: state)
                .font(.system(size: 32, weight: .semibold, design: .rounded).monospacedDigit())
                .foregroundColor(.white)
        }
    }

    @ViewBuilder
    private func countdown(state: PomodoroAttributes.ContentState) -> some View {
        if state.isPaused {
            Text(formatSeconds(state.remainingSeconds))
        } else {
            Text(timerInterval: Date()...state.endTime, countsDown: true)
        }
    }

    private func sessionTitle(_ type: String) -> String {
        switch type {
        case "work": return "Work"
        case "shortBreak": return "Short break"
        case "longBreak": return "Long break"
        default: return "Pomodoro"
        }
    }

    private func icon(_ type: String) -> String {
        switch type {
        case "work": return "timer"
        case "shortBreak": return "cup.and.saucer"
        case "longBreak": return "figure.walk"
        default: return "timer"
        }
    }

    private func formatSeconds(_ total: Int) -> String {
        let s = max(total, 0)
        return String(format: "%02d:%02d", s / 60, s % 60)
    }
}
