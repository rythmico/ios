import SwiftUI
import Sugar

struct LessonsView: View, TestableView {
    typealias Coordinator = APIActivityCoordinator<GetLessonPlansRequest>

    @ObservedObject
    private var coordinator: Coordinator
    @ObservedObject
    private var repository = Current.lessonPlanRepository
    @State
    private var selectedLessonPlan: LessonPlan?
    @State
    private var didAppear = false

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var lessonPlans: [LessonPlan] { repository.items }

    var onAppear: Handler<Self>?
    var body: some View {
        CollectionView(lessonPlans, padding: EdgeInsets(.spacingMedium)) { lessonPlan in
            NavigationLink(
                destination: LessonPlanDetailView(lessonPlan),
                tag: lessonPlan,
                selection: self.$selectedLessonPlan,
                label: { LessonPlanSummaryCell(lessonPlan: lessonPlan) }
            )
            .disabled(lessonPlan.status.isCancelled)
            .transition(self.transition(for: lessonPlan))
        }
        .accentColor(.rythmicoPurple)
        .onAppear { self.onAppear?(self) }
        .onAppear(perform: fetchOnAppear)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private func fetchOnAppear() {
        guard !didAppear else { return }
        coordinator.run()
        didAppear = true
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
    @ViewBuilder
    static var previews: some View {
        LessonsView(coordinator: Current.lessonPlanFetchingCoordinator()!)
            .environment(\.colorScheme, .light)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        LessonsView(coordinator: Current.lessonPlanFetchingCoordinator()!)
            .environment(\.colorScheme, .dark)
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
