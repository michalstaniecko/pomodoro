import SwiftUI
import WidgetKit

@main
struct PomodoroLiveActivityBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            PomodoroLiveActivityWidget()
        }
    }
}
