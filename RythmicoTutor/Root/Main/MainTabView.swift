import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView, RoutableView {
    enum Tab: String, Hashable {
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
        NavigationView {
            TabView(selection: $tab) {
                bookingRequestsTabView
                    .tag(Tab.requests)
                    .tabItem {
                        Image(systemSymbol: .musicNoteList).font(.system(size: 21, weight: .bold))
                        Text(Tab.requests.title)
                    }
                Text("Second View")
                    .font(.title)
                    .tag(Tab.profile)
                    .tabItem {
                        Image(systemSymbol: .personFill).font(.system(size: 21, weight: .semibold))
                        Text(Tab.profile.title)
                    }
            }
            .navigationBarTitle(Text(tab.title), displayMode: .large)
        }
        .navigationViewFixInteractiveDismissal()
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
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
#endif
