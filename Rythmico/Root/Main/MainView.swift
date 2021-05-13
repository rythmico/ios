import SwiftUI
import ComposableNavigator
import SFSafeSymbols
import FoundationSugar

struct MainView: View, TestableView {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case lessons = "Lessons"
        case profile = "Profile"

        var title: String { rawValue }
        var uppercasedTitle: String { title.uppercased(with: Current.locale) }
    }

    @ObservedObject
    private var tabSelection = Current.tabSelection

    let inspection = SelfInspection()
    var body: some View {
        MainViewContent(
            tabs: Tab.allCases, selection: $tabSelection.mainTab,
            content: content, tabTitle: \.uppercasedTitle, tabIcons: icon
        )
        .testable(self)
        .accentColor(.rythmicoPurple)
        .onAppear(perform: Current.deviceRegisterCoordinator.registerDevice)
        .onAppear(perform: Current.pushNotificationAuthorizationCoordinator.refreshAuthorizationStatus)
    }

    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .profile: ProfileView()
        case .lessons: Root(dataSource: Current.lessonsTabNavigation, pathBuilder: LessonsScreen.Builder())
        }
    }

    @ViewBuilder
    private func icon(for tab: Tab) -> some View {
        switch tab {
        case .lessons: Image(systemSymbol: .calendar).font(.system(size: 21, weight: .medium))
        case .profile: Image(systemSymbol: .person).font(.system(size: 21, weight: .semibold))
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environment(\.colorScheme, .light)
        MainView()
            .environment(\.colorScheme, .dark)
    }
}
#endif
