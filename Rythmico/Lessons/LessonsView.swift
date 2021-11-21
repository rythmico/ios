import StudentDO
import SwiftUIEncore
import Combine
import ComposableNavigator
import SwiftUI

struct LessonsScreen: Screen {
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                LessonsScreen.self,
                content: { LessonsView() },
                nesting: {
                    RequestLessonPlanScreen.Builder()

                    LessonPlanDetailScreen.Builder()
                    LessonDetailScreen.Builder()

                    LessonPlanPausingScreen.Builder()
                    LessonPlanResumingScreen.Builder()
                    LessonPlanCancellationScreen.Builder()

                    LessonPlanApplicationsScreen.Builder()

                    LessonSkippingScreen.Builder()
                }
            )
        }
    }
}

struct LessonsView: View, TestableView {
    enum Filter: String, CaseIterable {
        case upcoming
        case past
    }

    @Environment(\.scenePhase)
    private var scenePhase
    @ObservedObject
    private var tabSelection = Current.tabSelection
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen
    @ObservedObject
    private var lessonsTabNavigation = Current.lessonsTabNavigation
    @ObservedObject
    private var coordinator = Current.lessonPlanRequestFetchingCoordinator
    @State
    private var hasAutoPresentedRequestFlow = false
    @State
    private var hasRequestedAppStoreReview = false
    @ObservedObject
    private(set) var repository = Current.lessonPlanRequestRepository

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.output?.error }

    let inspection = SelfInspection()
    var body: some View {
        TitleContentView(title, spacing: .grid(1)) { _ in
            VStack(spacing: 0) {
                TabMenuView(tabs: Filter.allCases, selection: $tabSelection.lessonsTab)
                LessonsCollectionView(
                    isLoading: coordinator.state.isLoading,
                    lessonPlanRequests: repository.items,
                    filter: tabSelection.lessonsTab
                )
            }
        }
        .backgroundColor(.rythmico.background)
        .accentColor(.rythmico.picoteeBlue)
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: trailingItem)
        .testable(self)
        .onReceive(shouldFetchPublisher(), perform: fetch)
        // FIXME: double HTTP request for some reason
//        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: onLessonPlanRequestsFetched)
        .alertOnFailure(coordinator)
        .onReceive(Current.apiEventListener.on(.lessonPlanRequestsChanged)) {
            coordinator.reset()
        }
    }

    private var title: String { MainView.Tab.lessons.title }

    @ViewBuilder
    private var trailingItem: some View {
        Button.requestLessonPlan(action: presentRequestLessonFlow)
            .padding(.vertical, .grid(3))
            .padding(.horizontal, .grid(7))
            .offset(x: .grid(7))
            .accessibility(label: Text("Request lessons"))
            .accessibility(hint: Text("Double tap to request a lesson plan"))
    }

    func presentRequestLessonFlow() {
        navigator.go(to: RequestLessonPlanScreen(), on: currentScreen)
    }

    func onLessonPlanRequestsFetched(_ lessonPlanRequests: [LessonPlanRequest]) {
        repository.setItems(lessonPlanRequests)
        if lessonPlanRequests.isEmpty {
            if !hasAutoPresentedRequestFlow {
                hasAutoPresentedRequestFlow = true
                presentRequestLessonFlow()
            }
        } else {
            if Current.pushNotificationAuthorizationCoordinator.status.isNotDetermined {
                Current.pushNotificationAuthorizationCoordinator.requestAuthorization()
            } else if !hasRequestedAppStoreReview {
                hasRequestedAppStoreReview = true
                Current.appStoreReviewPrompt.requestReview()
            }
        }
    }

    private func shouldFetchPublisher() -> AnyPublisher<Void, Never> {
        coordinator.$state.zip(onLessonsTabRootPublisher()).b
    }

    private func onLessonsTabRootPublisher() -> AnyPublisher<Void, Never> {
        tabSelection.$mainTab.combineLatest(lessonsTabNavigation.$path.map(\.current))
            .filter { $0 == .lessons && $1.is(LessonsScreen()) }
            .mapToVoid()
            .eraseToAnyPublisher()
    }

    private func fetch() {
        guard Current.sceneState() == .active else { return }
        coordinator.startToIdle()
    }
}

#if DEBUG
struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsView()
            .environment(\.colorScheme, .light)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
