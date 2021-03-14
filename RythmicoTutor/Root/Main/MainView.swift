import SwiftUI
import SFSafeSymbols
import FoundationSugar

struct MainView: View, TestableView {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case schedule = "Schedule"
        case requests = "Requests"
        case profile = "Profile"

        var title: String { rawValue }
    }

    @ObservedObject
    private var state = Current.state

    @ObservedObject
    private var bookingFetchingCoordinator = Current.bookingsFetchingCoordinator
    private let deviceRegisterCoordinator: DeviceRegisterCoordinator

    init?() {
        guard
            let deviceRegisterCoordinator = Current.deviceRegisterCoordinator()
        else {
            return nil
        }
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
        case .profile: Image(systemSymbol: .personFill).font(.system(size: 21, weight: .semibold))
        }
    }

    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .schedule: BookingsTabView()
        case .requests: BookingRequestsTabView()
        case .profile: ProfileView()
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
