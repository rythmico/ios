import SwiftUI
import Combine
import ComposableNavigator
import FoundationSugar

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
                    LessonPlanApplicationsScreen.Builder()
                    LessonDetailScreen.Builder()
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
    private var coordinator = Current.lessonPlanFetchingCoordinator
    @State
    private var hasFetchedLessonPlansAtLeastOnce = false
    @ObservedObject
    private var repository = Current.lessonPlanRepository

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var lessonPlans: [LessonPlan] { repository.items }

    let inspection = SelfInspection()
    var body: some View {
        TitleContentView(title: MainView.Tab.lessons.title, spacing: .spacingUnit) {
            VStack(spacing: 0) {
                TabMenuView(tabs: Filter.allCases, selection: $tabSelection.lessonsTab)
                LessonsCollectionView(
                    previousLessonPlans: repository.previousItems,
                    currentLessonPlans: repository.items,
                    filter: tabSelection.lessonsTab
                )
            }
        }
        .backgroundColor(.rythmicoBackground)
        .accentColor(.rythmicoPurple)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: leadingItem, trailing: trailingItem)
        .testable(self)
        .onReceive(shouldFetchPublisher(), perform: fetch)
        // FIXME: double HTTP request for some reason
//        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: onLessonPlansFetched)
        .alertOnFailure(coordinator)
    }

    @ViewBuilder
    private var leadingItem: some View {
        if coordinator.state.isLoading {
            ActivityIndicator(color: .rythmicoGray90)
        }
    }

    @ViewBuilder
    private var trailingItem: some View {
        Button(action: presentRequestLessonFlow) {
            Image(decorative: Asset.buttonRequestLessons.name)
                .padding(.vertical, .spacingExtraSmall)
                .padding(.horizontal, .spacingExtraLarge)
                .offset(x: .spacingExtraLarge)
        }
        .accessibility(label: Text("Request lessons"))
        .accessibility(hint: Text("Double tap to request a lesson plan"))
    }

    func presentRequestLessonFlow() {
        navigator.go(to: RequestLessonPlanScreen(), on: currentScreen)
    }

    func onLessonPlansFetched(_ lessonPlans: [LessonPlan]) {
        repository.setItems(lessonPlans)
        guard !hasFetchedLessonPlansAtLeastOnce else { return }
        hasFetchedLessonPlansAtLeastOnce = true
        if lessonPlans.isEmpty {
            presentRequestLessonFlow()
        } else {
            Current.pushNotificationAuthorizationCoordinator.requestAuthorization()
        }
    }

    private func shouldFetchPublisher() -> AnyPublisher<Void, Never> {
        coordinator.$state.zip(onLessonsTabRootPublisher()).b
    }

    private func onLessonsTabRootPublisher() -> AnyPublisher<Void, Never> {
        tabSelection.$mainTab.combineLatest(lessonsTabNavigation.$path.map(\.current))
            .filter { $0 == .lessons && $1.is(LessonsScreen()) }
            .map { _ in () }
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
