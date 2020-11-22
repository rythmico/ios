import SwiftUI
import SFSafeSymbols
import Sugar

struct MainView: View, TestableView {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case schedule = "Schedule"
        case requests = "Requests"

        var title: String { rawValue }
    }

    @ObservedObject
    private var state = Current.state

    @ObservedObject
    private var bookingFetchingCoordinator: BookingsView.Coordinator
    private let deviceRegisterCoordinator: DeviceRegisterCoordinator

    init?() {
        guard
            let bookingFetchingCoordinator = Current.sharedCoordinator(for: \.bookingsFetchingService),
            let deviceRegisterCoordinator = Current.deviceRegisterCoordinator()
        else {
            return nil
        }
        self.bookingFetchingCoordinator = bookingFetchingCoordinator
        self.deviceRegisterCoordinator = deviceRegisterCoordinator
    }

    let inspection = SelfInspection()
    var body: some View {
        MainViewContent(
            tabs: Tab.allCases, selection: $state.tab,
            navigationTitle: \.title, leadingItem: leadingItem, trailingItem: trailingItem,
            content: content,
            tabTitle: \.title, tabIcons: icon
        )
        .testable(self)
        .onAppear(perform: deviceRegisterCoordinator.registerDevice)
    }

    @ViewBuilder
    private func icon(for tab: Tab) -> some View {
        switch tab {
        case .schedule: Image(systemSymbol: .calendar).font(.system(size: 21, weight: .semibold))
        case .requests: Image(systemSymbol: .musicNoteList).font(.system(size: 21, weight: .bold))
        }
    }

    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .schedule: BookingsTabView()
        case .requests: BookingRequestsTabView()
        }
    }

    @ViewBuilder
    private func leadingItem(for tab: Tab) -> some View {
        switch tab {
        case .schedule where bookingFetchingCoordinator.state.isLoading:
            ActivityIndicator()
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func trailingItem(for tab: Tab) -> some View {
        EmptyView()
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
