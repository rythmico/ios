import SwiftUI
import SFSafeSymbols
import Sugar

struct MainTabView: View, TestableView, RoutableView {
    enum Tab: String, Hashable {
        case lessons = "Lessons"
        case profile = "Profile"

        var title: String { rawValue }
        var uppercasedTitle: String { title.uppercased(with: Current.locale) }
    }

    final class ViewState: ObservableObject {
        @Published var tab: Tab = .lessons
        @Published var isLessonRequestViewPresented = false
    }

    @ObservedObject
    private(set) var state = ViewState()

    private let lessonsView: LessonsView
    private let profileView: ProfileView = ProfileView()

    @State
    private var hasPresentedLessonRequestView = false

    // TODO: potentially use @StateObject to simplify RootView
    @ObservedObject
    private var lessonPlanFetchingCoordinator: LessonsView.Coordinator
    private let deviceRegisterCoordinator: DeviceRegisterCoordinator

    init?() {
        guard
            let lessonPlanFetchingCoordinator = Current.coordinator(for: \.lessonPlanFetchingService),
            let deviceRegisterCoordinator = Current.deviceRegisterCoordinator()
        else {
            return nil
        }
        self.lessonsView = LessonsView(coordinator: lessonPlanFetchingCoordinator)
        self.lessonPlanFetchingCoordinator = lessonPlanFetchingCoordinator
        self.deviceRegisterCoordinator = deviceRegisterCoordinator
    }

    func presentRequestLessonFlow() {
        state.isLessonRequestViewPresented = true
    }

    func presentRequestLessonFlowIfNeeded(_ lessonPlans: [LessonPlan]) {
        guard !hasPresentedLessonRequestView else { return }
        state.isLessonRequestViewPresented = lessonPlans.isEmpty
    }

    let inspection = SelfInspection()
    var body: some View {
        NavigationView {
            TabView(selection: $state.tab) {
                lessonsView
                    .tag(Tab.lessons)
                    .tabItem {
                        Image(systemSymbol: .calendar).font(.system(size: 21, weight: .medium))
                        Text(Tab.lessons.uppercasedTitle)
                    }

                profileView
                    .tag(Tab.profile)
                    .tabItem {
                        Image(systemSymbol: .person).font(.system(size: 21, weight: .semibold))
                        Text(Tab.profile.uppercasedTitle)
                    }
            }
            .navigationBarTitle(Text(state.tab.title), displayMode: .large)
            .navigationBarItems(leading: leadingNavigationItem, trailing: trailingNavigationItem)
        }
        .testable(self)
        .modifier(BestNavigationStyleModifier())
        .onReceive(state.$tab, perform: onTabSelectionChange)
        .onReceive(state.$isLessonRequestViewPresented, perform: onIsLessonRequestViewPresentedChange)
        .accentColor(.rythmicoPurple)
        .onAppear(perform: deviceRegisterCoordinator.registerDevice)
        .onSuccess(lessonPlanFetchingCoordinator, perform: presentRequestLessonFlowIfNeeded)
        .sheet(isPresented: $state.isLessonRequestViewPresented) {
            RequestLessonPlanView(context: RequestLessonPlanContext())
        }
        .routable(self)
    }

    func handleRoute(_ route: Route) {
        switch route {
        case .lessons:
            state.tab = .lessons
            Current.router.end()
        case .requestLessonPlan:
            state.tab = .lessons
            presentRequestLessonFlow()
            Current.router.end()
        case .profile:
            state.tab = .profile
            Current.router.end()
        }
    }

    private var leadingNavigationItem: AnyView? {
        switch state.tab {
        case .lessons:
            return AnyView(
                Group {
                    if lessonPlanFetchingCoordinator.state.isLoading {
                        ActivityIndicator(style: .medium, color: .rythmicoGray90)
                    }
                }
            )
        case .profile:
            return nil
        }
    }

    private var trailingNavigationItem: AnyView? {
        switch state.tab {
        case .lessons:
            return AnyView(
                Button(action: presentRequestLessonFlow) {
                    Image(systemSymbol: .plusCircleFill).font(.system(size: 24))
                        .padding(.vertical, .spacingExtraSmall)
                        .padding(.horizontal, .spacingExtraLarge)
                        .offset(x: .spacingExtraLarge)
                }
                .accessibility(label: Text("Request lessons"))
                .accessibility(hint: Text("Double tap to request a lesson plan"))
            )
        case .profile:
            return nil
        }
    }

    private func onTabSelectionChange(_ newTab: Tab) { let oldTab = state.tab
        if oldTab != newTab, newTab == .lessons {
            lessonPlanFetchingCoordinator.run()
        }
    }

    private func onIsLessonRequestViewPresentedChange(_ flag: Bool) {
        if flag { hasPresentedLessonRequestView = true }
    }
}

private struct BestNavigationStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        UIDevice.current.userInterfaceIdiom == .phone
            ? AnyView(content.navigationViewStyle(StackNavigationViewStyle()))
            : AnyView(content.navigationViewStyle(DefaultNavigationViewStyle()))
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    @ViewBuilder
    static var previews: some View {
        MainTabView()
            .environment(\.colorScheme, .light)
        MainTabView()
            .environment(\.colorScheme, .dark)
    }
}
#endif
