import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView, RoutableView {
    enum Tab: String, Hashable, CaseIterable {
        case requests = "Requests"
        case profile = "Profile"

        var title: String { rawValue }
    }

    @State
    private var tab: Tab = .requests
    @State
    private var bookingRequestsTabView: BookingRequestsTabView

    private let deviceRegisterCoordinator: DeviceRegisterCoordinator

    init?() {
        guard
            let bookingRequestsTabView = BookingRequestsTabView(),
            let deviceRegisterCoordinator = Current.deviceRegisterCoordinator()
        else {
            return nil
        }
        self._bookingRequestsTabView = .init(wrappedValue: bookingRequestsTabView)
        self.deviceRegisterCoordinator = deviceRegisterCoordinator
    }

    let inspection = SelfInspection()
    var body: some View {
        MainViewContent(
            tabs: Tab.allCases, selection: $tab,
            navigationTitle: \.title, leadingItem: leadingItem, trailingItem: trailingItem,
            content: content,
            tabTitle: \.title, tabIcons: icon
        )
        .testable(self)
        .routable(self)
        .onAppear(perform: deviceRegisterCoordinator.registerDevice)
    }

    func handleRoute(_ route: Route) {
        switch route {
        case .bookingRequests, .bookingApplications:
            tab = .requests
        }
    }

    @ViewBuilder
    private func icon(for tab: Tab) -> some View {
        switch tab {
        case .requests: Image(systemSymbol: .musicNoteList).font(.system(size: 21, weight: .bold))
        case .profile: Image(systemSymbol: .personFill).font(.system(size: 21, weight: .semibold))
        }
    }

    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .requests: bookingRequestsTabView
        case .profile: Text("Profile")
        }
    }

    @ViewBuilder
    private func leadingItem(for tab: Tab) -> some View {
        EmptyView()
    }

    @ViewBuilder
    private func trailingItem(for tab: Tab) -> some View {
        EmptyView()
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
#endif
