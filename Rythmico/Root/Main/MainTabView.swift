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
        @Published var isLessonRequestViewPresented = false
    }

    @StateObject
    var state = ViewState()

    @State
    private var tab: Tab = .lessons
    @State
    private var lessonsView: LessonsView
    @State
    private var profileView = ProfileView()

    @State
    private var hasPresentedLessonRequestView = false

    @ObservedObject
    private var lessonPlanFetchingCoordinator: LessonsView.Coordinator
    private let deviceRegisterCoordinator: DeviceRegisterCoordinator

    init?() {
        guard
            let lessonPlanFetchingCoordinator = Current.sharedCoordinator(for: \.lessonPlanFetchingService),
            let deviceRegisterCoordinator = Current.deviceRegisterCoordinator()
        else {
            return nil
        }
        self._lessonsView = .init(wrappedValue: LessonsView(coordinator: lessonPlanFetchingCoordinator))
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
            TabView(selection: $tab) {
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

            .navigationBarTitle(Text(tab.title), displayMode: .large)
            .navigationBarItems(leading: leadingNavigationItem, trailing: trailingNavigationItem)
        }
        .navigationViewFixInteractiveDismissal()
        .testable(self)
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
            tab = .lessons
            Current.router.end()
        case .requestLessonPlan:
            tab = .lessons
            presentRequestLessonFlow()
            Current.router.end()
        case .profile:
            tab = .profile
            Current.router.end()
        }
    }

    @ViewBuilder
    private var leadingNavigationItem: some View {
        switch tab {
        case .lessons where lessonPlanFetchingCoordinator.state.isLoading:
            ActivityIndicator(color: .rythmicoGray90)
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private var trailingNavigationItem: some View {
        switch tab {
        case .lessons:
            Button(action: presentRequestLessonFlow) {
                Image(systemSymbol: .plusCircleFill).font(.system(size: 24))
                    .padding(.vertical, .spacingExtraSmall)
                    .padding(.horizontal, .spacingExtraLarge)
                    .offset(x: .spacingExtraLarge)
            }
            .accessibility(label: Text("Request lessons"))
            .accessibility(hint: Text("Double tap to request a lesson plan"))
        case .profile:
            EmptyView()
        }
    }

    private func onIsLessonRequestViewPresentedChange(_ flag: Bool) {
        if flag { hasPresentedLessonRequestView = true }
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environment(\.colorScheme, .light)
        MainTabView()
            .environment(\.colorScheme, .dark)
    }
}
#endif
