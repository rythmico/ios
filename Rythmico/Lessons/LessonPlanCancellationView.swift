import SwiftUI
import Sugar

struct LessonPlanCancellationView: View, TestableView, Identifiable {
    private typealias Coordinator = APIActivityCoordinator<CancelLessonPlanRequest>

    @Environment(\.betterSheetPresentationMode)
    private var presentationMode

    @State
    private var isCancellationIntended = false
    @ObservedObject
    private var coordinator: Coordinator
    private var lessonPlan: LessonPlan
    private var onSuccessfulCancellation: Action

    init?(lessonPlan: LessonPlan, onSuccessfulCancellation: @escaping Action) {
        guard let coordinator = Current.lessonPlanCancellationCoordinator() else {
            return nil
        }
        self.coordinator = coordinator
        self.lessonPlan = lessonPlan
        self.onSuccessfulCancellation = onSuccessfulCancellation
    }

    let id = UUID()
    var error: Error? { coordinator.state.failureValue }

    func submit(_ reason: LessonPlan.CancellationInfo.Reason) {
        coordinator.run(with: (lessonPlanId: lessonPlan.id, body: .init(reason: reason)))
    }

    var onAppear: Handler<Self>?
    var body: some View {
        NavigationView {
            ZStack {
                if isUserInputRequired {
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
                } else if coordinator.state.isLoading {
                    LoadingView()
                        .transition(
                            .asymmetric(insertion: .move(edge: .trailing), removal: .opacity)
                        )
                } else if coordinator.state.isSuccess {
                    ConfirmationView().transition(.opacity)
                }
            }
            .onEdgeSwipe(.left, perform: back)
            .padding(.top, .spacingExtraSmall)
            .navigationBarTitle("", displayMode: .inline)
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
        .accentColor(.rythmicoGray90)
        .animation(.rythmicoSpring(duration: .durationMedium), value: isCancellationIntended)
        .animation(.rythmicoSpring(duration: .durationMedium), value: isUserInputRequired)
        .onAppear { self.onAppear?(self) }
        .onSuccess(coordinator, perform: lessonPlanSuccessfullyCancelled)
        .alertOnFailure(coordinator)
    }

    private var isUserInputRequired: Bool {
        coordinator.state.isIdle || coordinator.state.isFailure
    }

    private func lessonPlanSuccessfullyCancelled(_ lessonPlan: LessonPlan) {
        Current.lessonPlanRepository.replaceIdentifiableItem(lessonPlan)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss()
            self.onSuccessfulCancellation()
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
        LessonPlanCancellationView(
            lessonPlan: .jackGuitarPlanStub,
            onSuccessfulCancellation: {}
        )
    }
}
#endif
