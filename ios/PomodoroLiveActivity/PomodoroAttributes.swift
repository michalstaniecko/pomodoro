import ActivityKit
import Foundation

@available(iOS 16.1, *)
struct PomodoroAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var sessionType: String
        var endTime: Date
        var isPaused: Bool
        var remainingSeconds: Int
    }
}
