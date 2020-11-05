import SwiftUI
import Sugar

struct LessonsView: View, TestableView, VisibleView {
    typealias Coordinator = APIActivityCoordinator<GetLessonPlansRequest>

    @ObservedObject
    private(set) var coordinator: Coordinator
    @ObservedObject
    private var repository = Current.lessonPlanRepository
    @State
    var isVisible = false

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var lessonPlans: [LessonPlan] { repository.items }

    let inspection = SelfInspection()
    var body: some View {
        LessonsCollectionView(
            previousLessonPlans: repository.previousItems,
            currentLessonPlans: repository.items
        )
        .accentColor(.rythmicoPurple)
        .testable(self)
        .visible(self)
        .onAppearOrForeground(self, perform: coordinator.startToIdle)
        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
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
