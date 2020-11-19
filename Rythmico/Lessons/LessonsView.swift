import SwiftUI
import Combine
import Sugar

struct LessonsView: View, TestableView {
    typealias Coordinator = APIActivityCoordinator<GetLessonPlansRequest>

    enum Filter: String, CaseIterable {
        case upcoming
        case past
    }

    @Environment(\.scenePhase)
    private var scenePhase
    @ObservedObject
    private var state = Current.state
    @ObservedObject
    private(set) var coordinator: Coordinator
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
        .padding(.top, .spacingSmall)
        .accentColor(.rythmicoPurple)
        .testable(self)
        .onReceive(coordinator.$state.zip(state.onLessonsTabRootPublisher).b, perform: fetch)
        // FIXME: double HTTP request for some reason
//        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private func fetch() {
        guard Current.sceneState == .active else { return }
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
        LessonsView(coordinator: Current.sharedCoordinator(for: \.lessonPlanFetchingService)!)
            .environment(\.colorScheme, .light)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
