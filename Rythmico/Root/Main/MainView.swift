import SwiftUIEncore
import ComposableNavigator

struct MainView: View, TestableView {
    enum Tab: String, Equatable, Hashable, CaseIterable {
        case lessons = "Lessons"
        case profile = "Profile"

        var title: String { rawValue }
        var uppercasedTitle: String { title.uppercased(with: Current.locale()) }
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
        .accentColor(.rythmico.picoteeBlue)
        .onAppear(perform: Current.pushNotificationAuthorizationCoordinator.refreshAuthorizationStatus)
    }

    @ViewBuilder
    private func content(for tab: Tab) -> some View {
        switch tab {
        case .lessons: Root(dataSource: Current.lessonsTabNavigation, pathBuilder: LessonsScreen.Builder())
        case .profile: Root(dataSource: Current.profileTabNavigation, pathBuilder: ProfileScreen.Builder())
        }
    }

    @ViewBuilder
    private func icon(for tab: Tab) -> some View {
        switch tab {
        case .lessons: Image(decorative: Asset.Icon.Tab.lessons.name).renderingMode(.template)
        case .profile: Image(decorative: Asset.Icon.Tab.profile.name).renderingMode(.template)
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
