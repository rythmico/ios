import SwiftUISugar
import ComposableNavigator

struct LessonPlanCancellationScreen: Screen {
    let lessonPlan: LessonPlan
    let option: LessonPlan.Options.Cancel
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    init?(lessonPlan: LessonPlan) {
        guard let option = lessonPlan.options.cancel else { return nil }
        self.lessonPlan = lessonPlan
        self.option = option
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanCancellationScreen) in
                    LessonPlanCancellationView(lessonPlan: screen.lessonPlan, option: screen.option)
                }
            )
        }
    }
}

struct LessonPlanCancellationView: View, TestableView {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    @State
    private var isCancellationIntended = false
    @StateObject
    private var coordinator = Current.lessonPlanCancellationCoordinator()

    let lessonPlan: LessonPlan
    let option: LessonPlan.Options.Cancel

    var error: Error? { coordinator.state.failureValue }

    func submit(_ reason: LessonPlan.CancellationInfo.Reason) {
        coordinator.run(with: (lessonPlanId: lessonPlan.id, body: .init(reason: reason)))
    }

    let inspection = SelfInspection()
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                backButton: {
                    if isUserInputRequired && isCancellationIntended {
                        BackButton(action: back).transition(.opacity)
                    }
                },
                trailingItem: { CloseButton(action: dismiss) }
            )
            CoordinatorStateView(
                coordinator: coordinator,
                successTitle: "Plan cancelled successfully",
                loadingTitle: "Cancelling plan..."
            ) {
                if !isCancellationIntended {
                    PromptView(lessonPlan: lessonPlan, policy: option.policy, noAction: dismiss, yesAction: showReasonView)
                        .transition(
                            .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
                        )
                } else {
                    ReasonView(lessonPlan: lessonPlan, submitHandler: submit)
                        .transition(
                            .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                        )
                }
            }
            .onEdgeSwipe(.left, perform: back)
        }
        .backgroundColor(.rythmico.backgroundSecondary)
        .interactiveDismissDisabled(isCancellationIntended)
        .accentColor(.rythmico.gray90)
        .animation(.rythmicoSpring(duration: .durationMedium), value: isCancellationIntended)
        .animation(.rythmicoSpring(duration: .durationMedium), value: isUserInputRequired)
        .testable(self)
        .onSuccess(coordinator, perform: lessonPlanSuccessfullyCancelled)
        .alertOnFailure(coordinator)
    }

    private var isUserInputRequired: Bool {
        coordinator.state.isReady || coordinator.state.isFailure
    }

    private func lessonPlanSuccessfullyCancelled(_ lessonPlan: LessonPlan) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Current.lessonPlanRepository.replaceById(lessonPlan)
            // Either, depending on which tab we're on.
            navigator.goBack(to: LessonPlansScreen())
            navigator.goBack(to: LessonsScreen())
        }
    }

    private func dismiss() {
        navigator.dismiss(screen: currentScreen)
    }

    private func showReasonView() {
        isCancellationIntended = true
    }

    private func back() {
        isCancellationIntended = false
    }
}

#if DEBUG
struct LessonPlanCancellationView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanCancellationView(lessonPlan: .pendingJackGuitarPlanStub, option: .stub)
    }
}
#endif
