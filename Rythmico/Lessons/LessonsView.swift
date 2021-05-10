import SwiftUI
import Combine
import FoundationSugar

struct LessonsView: View, TestableView {
    enum Filter: String, CaseIterable {
        case upcoming
        case past
    }

    @Environment(\.scenePhase)
    private var scenePhase
    @ObservedObject
    private var navigation = Current.navigation
    @ObservedObject
    private var coordinator = Current.lessonPlanFetchingCoordinator
    @ObservedObject
    private var repository = Current.lessonPlanRepository

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var lessonPlans: [LessonPlan] { repository.items }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            TabMenuView(tabs: Filter.allCases, selection: $navigation.lessonsFilter)
            LessonsCollectionView(
                previousLessonPlans: repository.previousItems,
                currentLessonPlans: repository.items,
                filter: navigation.lessonsFilter
            )
        }
        .accentColor(.rythmicoPurple)
        .testable(self)
        .onReceive(coordinator.$state.zip(navigation.onLessonsTabRootPublisher).b, perform: fetch)
        // FIXME: double HTTP request for some reason
//        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
        .detail(item: $navigation.lessonsNavigation.viewingLesson, content: LessonDetailView.init)
        .detail(item: $navigation.lessonsNavigation.viewingLessonPlan) { LessonPlanDetailView(lessonPlan: $0, context: $navigation.lessonsNavigation) }
        .detail(item: $navigation.lessonsNavigation.reviewingLessonPlan, content: LessonPlanApplicationsView.init)
    }

    private func fetch() {
        guard Current.sceneState() == .active else { return }
        coordinator.startToIdle()
    }
}

private extension AppNavigation {
    var onLessonsTabRootPublisher: AnyPublisher<Void, Never> {
        $selectedTab.combineLatest($lessonsNavigation)
            .filter { $0 == (.lessons, .none) }
            .map { _ in () }
            .eraseToAnyPublisher()
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
