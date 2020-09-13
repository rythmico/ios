import SwiftUI
import Sugar

struct LessonsView: View, TestableView, VisibleView {
    typealias Coordinator = APIActivityCoordinator<GetLessonPlansRequest>

    @ObservedObject
    private var coordinator: Coordinator
    @ObservedObject
    private var repository = Current.lessonPlanRepository
    @State
    private(set) var isVisible = false; var isVisibleBinding: Binding<Bool> { $isVisible }

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var lessonPlans: [LessonPlan] { repository.items }

    let inspection = SelfInspection()
    var body: some View {
        CollectionView(lessonPlans) { lessonPlan in
            LessonPlanSummaryCell(lessonPlan: lessonPlan)
                .transition(transition(for: lessonPlan))
        }
        .accentColor(.rythmicoPurple)
        .testable(self)
        .visible(self)
        .onAppearOrForeground(self, perform: coordinator.startToIdle)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private func transition(for lessonPlan: LessonPlan) -> AnyTransition {
        let transitionDelay = repository.items
            .firstIndex(of: lessonPlan)
            .flatMap { repository.previousItems.isNilOrEmpty ? $0 : nil }
            .map { Double($0) * (.durationShort * 2/3) }

        return AnyTransition.opacity.combined(with: .scale(scale: 0.8))
            .animation(
                Animation
                    .rythmicoSpring(duration: .durationMedium)
                    .delay(transitionDelay ?? 0)
            )
    }
}

#if DEBUG
struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsView(coordinator: Current.sharedCoordinator(for: \.lessonPlanFetchingService)!)
            .environment(\.colorScheme, .light)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        LessonsView(coordinator: Current.sharedCoordinator(for: \.lessonPlanFetchingService)!)
            .environment(\.colorScheme, .dark)
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
