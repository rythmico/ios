import SwiftUI
import FoundationSugar

struct LessonPlanCancellationView: View, TestableView {
    @Environment(\.presentationMode)
    private var presentationMode

    @State
    private var isCancellationIntended = false
    @StateObject
    private var coordinator = Current.lessonPlanCancellationCoordinator()

    var lessonPlan: LessonPlan

    init?(lessonPlan: LessonPlan) {
        guard !lessonPlan.status.isCancelled else { return nil }
        self.lessonPlan = lessonPlan
    }

    var error: Error? { coordinator.state.failureValue }

    func submit(_ reason: LessonPlan.CancellationInfo.Reason) {
        coordinator.run(with: (lessonPlanId: lessonPlan.id, body: .init(reason: reason)))
    }

    let inspection = SelfInspection()
    var body: some View {
        NavigationView {
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
            .padding(.top, .spacingExtraSmall)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Group {
                    if isUserInputRequired && isCancellationIntended {
                        BackButton(action: back)
                    }
                },
                trailing: Group {
                    if isUserInputRequired {
                        CloseButton(action: dismiss)
                    }
                }
            )
        }
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
            Current.state.lessonsContext = .none
        }
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
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
