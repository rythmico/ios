import SwiftUI
import Sugar

struct LessonPlanCancellationView: View, TestableView {
    private typealias Coordinator = APIActivityCoordinator<CancelLessonPlanRequest>

    @Environment(\.presentationMode)
    private var presentationMode

    @State
    private var isCancellationIntended = false
    @StateObject
    private var coordinator: Coordinator
    private var lessonPlan: LessonPlan

    init?(lessonPlan: LessonPlan) {
        guard let coordinator = Current.coordinator(for: \.lessonPlanCancellationService) else {
            return nil
        }
        self._coordinator = .init(wrappedValue: coordinator)
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
                    PromptView(noAction: dismiss, yesAction: showReasonView)
                        .transition(
                            .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
                        )
                } else {
                    ReasonView(submitHandler: submit)
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
        Current.lessonPlanRepository.replaceById(lessonPlan)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
