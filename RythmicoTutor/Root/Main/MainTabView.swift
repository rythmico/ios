import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView, RoutableView {
    enum Tab: String, Hashable {
        case requests = "Requests"
        case profile = "Profile"

        var title: String { rawValue }
    }

    final class ViewState: ObservableObject {
        @Published var tab: Tab = .requests
    }

    @ObservedObject
    private var state = ViewState()

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
        NavigationView {
            TabView(selection: $state.tab) {
                BookingRequestsTabView()
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
            .navigationBarTitle(Text(state.tab.title), displayMode: .automatic)
        }
        .testable(self)
        .onAppear(perform: deviceRegisterCoordinator.registerDevice)
        .routable(self)
    }

    func handleRoute(_ route: Route) {
        switch route {
        case .bookingRequests, .bookingApplications:
            state.tab = .requests
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
