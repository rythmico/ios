import SwiftUI
import Sugar

struct LessonsView: View, TestableView {
    @ObservedObject
    private var fetchingCoordinator: LessonPlanFetchingCoordinator
    @ObservedObject
    private var lessonPlanRepository = Current.lessonPlanRepository
    @State
    private var selectedLessonPlan: LessonPlan?
    @State
    private var didAppear = false

    init(coordinator: LessonPlanFetchingCoordinator) {
        self.fetchingCoordinator = coordinator
        self.lessonPlanRepository = lessonPlanRepository
    }

    var lessonPlans: [LessonPlan] { lessonPlanRepository.lessonPlans }
    var isLoading: Bool { fetchingCoordinator.state.isLoading }
    var errorMessage: String? { fetchingCoordinator.state.failureValue?.localizedDescription }

    func fetchLessonPlans() {
        fetchingCoordinator.fetchLessonPlans()
    }

    func dismissErrorAlert() {
        fetchingCoordinator.dismissError()
    }

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
        .alert(error: self.errorMessage, dismiss: dismissErrorAlert)
        .onAppear { self.onAppear?(self) }
        .onAppear(perform: fetchOnAppear)
    }

    private func fetchOnAppear() {
        guard !didAppear else { return }
        fetchingCoordinator.fetchLessonPlans()
        didAppear = true
    }

    private func transition(for lessonPlan: LessonPlan) -> AnyTransition {
        let transitionDelay: Double
        if
            lessonPlanRepository.previousLessonPlans.isEmpty,
            let index = lessonPlanRepository.lessonPlans.firstIndex(of: lessonPlan)
        {
            transitionDelay = Double(index) * (.durationShort * 2/3)
        } else {
            transitionDelay = 0
        }
        return AnyTransition.opacity.combined(with: .scale(scale: 0.8))
            .animation(
                Animation
                    .rythmicoSpring(duration: .durationMedium)
                    .delay(transitionDelay)
            )
    }
}

#if DEBUG
struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()
        Current.lessonPlanFetchingService = LessonPlanFetchingServiceStub(
            result: .success([.davidGuitarPlanStub, .cancelledJackGuitarPlanStub]),
//            result: .failure("Something"),
//            delay: 2
            delay: nil
        )
        return Group {
            LessonsView(coordinator: Current.lessonPlanFetchingCoordinator()!)
                .environment(\.colorScheme, .light)
//                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            LessonsView(coordinator: Current.lessonPlanFetchingCoordinator()!)
                .environment(\.colorScheme, .dark)
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
    }
}
#endif
