import SwiftUI
import FoundationSugar

final class TabSelection: ObservableObject {
    @Published var mainTab: MainView.Tab = .lessons
    @Published var lessonsTab: LessonsView.Filter = .upcoming

    func reset() {
        mainTab = .lessons
        lessonsTab = .upcoming
    }
}
