import SwiftUISugar

final class TabSelection: ObservableObject {
    @Published var mainTab: MainView.Tab = .schedule
    @Published var scheduleTab: BookingsTabView.Tab = .upcoming
    @Published var requestsTab: BookingRequestsTabView.Tab = .open

    func reset() {
        mainTab = .schedule
        scheduleTab = .upcoming
        requestsTab = .open
    }
}
