import SwiftUI
import ComposableNavigator
import FoundationSugar

struct LessonPlanCancellationScreen: Screen {
    let lessonPlan: LessonPlan
    let presentationStyle: ScreenPresentationStyle = .sheet(allowsPush: false)

    init?(lessonPlan: LessonPlan) {
        guard !lessonPlan.status.isCancelled else { return nil }
        self.lessonPlan = lessonPlan
    }

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanCancellationScreen) in
                    LessonPlanCancellationView(lessonPlan: screen.lessonPlan)
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

    var lessonPlan: LessonPlan

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
                    PromptView(lessonPlan: lessonPlan, noAction: dismiss, yesAction: showReasonView)
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
        .backgroundColor(.rythmicoBackgroundSecondary)
        .sheetInteractiveDismissal(!isCancellationIntended)
        .accentColor(.rythmicoGray90)
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
            navigator.goBack(to: .root)
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
        LessonPlanCancellationView(lessonPlan: .pendingJackGuitarPlanStub)
    }
}
#endif
