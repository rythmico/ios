import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView {
    enum TabSelection: String, Hashable {
        case requests = "Requests"
        case profile = "Profile"

        var title: String { rawValue }
    }

    final class ViewState: ObservableObject {
        @Published var tabSelection: TabSelection = .requests
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

    var onAppear: Handler<Self>?
    var body: some View {
        TabView(selection: $state.tabSelection) {
            Text("First View")
                .font(.title)
                .tag(TabSelection.requests)
                .tabItem {
                    Image(systemSymbol: .musicNoteList).font(.system(size: 21, weight: .bold))
                    Text(TabSelection.requests.title)
                }
            Text("Second View")
                .font(.title)
                .tag(TabSelection.profile)
                .tabItem {
                    Image(systemSymbol: .personFill).font(.system(size: 21, weight: .semibold))
                    Text(TabSelection.profile.title)
                }
        }
        .onAppear { self.onAppear?(self) }
        .onAppear(perform: deviceRegisterCoordinator.registerDevice)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()

        return MainTabView()
    }
}
