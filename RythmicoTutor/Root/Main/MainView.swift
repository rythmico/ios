import SwiftUI
import SFSafeSymbols
import Sugar

struct MainView: View, TestableView {
    enum Tab: String, Hashable, CaseIterable {
        case requests = "Requests"
        case profile = "Profile"

        var title: String { rawValue }
    }

    @ObservedObject
    private var state = Current.state
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
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
