import SwiftUISugar
import ComposableNavigator

struct MainView: View, TestableView {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case schedule = "Schedule"
        case requests = "Requests"
        case profile = "Profile"

        var title: String { rawValue }
    }

    @ObservedObject
    private var tabSelection = Current.tabSelection

    let inspection = SelfInspection()
    var body: some View {
        MainViewContent(
            tabs: Tab.allCases, selection: $tabSelection.mainTab,
            content: content, tabTitle: \.title, tabIcons: icon
        )
        .testable(self)
        .onAppear(perform: Current.deviceRegisterCoordinator.registerDevice)
    }

    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .schedule: Root(dataSource: Current.bookingsTabNavigation, pathBuilder: BookingsTabScreen.Builder())
        case .requests: Root(dataSource: Current.bookingRequestsTabNavigation, pathBuilder: BookingRequestsTabScreen.Builder())
        case .profile: NavigationView { ProfileView() }
        }
    }

    @ViewBuilder
    private func icon(for tab: Tab) -> some View {
        switch tab {
        case .schedule: Image(systemSymbol: .calendar).font(.system(size: 21, weight: .semibold))
        case .requests: Image(systemSymbol: .musicNoteList).font(.system(size: 21, weight: .bold))
        case .profile: Image(systemSymbol: .personFill).font(.system(size: 21, weight: .semibold))
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
