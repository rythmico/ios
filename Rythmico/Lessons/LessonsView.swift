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
    private var state = Current.state
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
            TabMenuView(tabs: Filter.allCases, selection: $state.lessonsFilter)
            LessonsCollectionView(
                previousLessonPlans: repository.previousItems,
                currentLessonPlans: repository.items,
                filter: state.lessonsFilter
            )
        }
        .accentColor(.rythmicoPurple)
        .testable(self)
        .onReceive(coordinator.$state.zip(state.onLessonsTabRootPublisher).b, perform: fetch)
        // FIXME: double HTTP request for some reason
//        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
        .detail(item: $state.lessonsContext.viewingLesson, content: LessonDetailView.init)
        .detail(item: $state.lessonsContext.viewingLessonPlan) { LessonPlanDetailView(lessonPlan: $0, context: $state.lessonsContext) }
        .detail(item: $state.lessonsContext.reviewingLessonPlan, content: LessonPlanApplicationsView.init)
    }

    private func fetch() {
        guard Current.sceneState() == .active else { return }
        coordinator.startToIdle()
    }
}

private extension AppState {
    var onLessonsTabRootPublisher: AnyPublisher<Void, Never> {
        $tab.combineLatest($lessonsContext)
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
