import SwiftUISugar

extension LessonPlanCancellationView {
    struct ReasonView: View, TestableView {
        typealias Reason = LessonPlan.CancellationInfo.Reason

        private static let invalidReasons: [Reason] = [.rearrangementNeeded]

        var lessonPlan: LessonPlan
        var submitHandler: Handler<Reason>

        @State
        var selectedReason: Reason?
        @State
        private var isPresentingReschedulingAlert = false

        var submitButtonAction: Action? {
            guard
                let reason = selectedReason,
                Self.invalidReasons.contains(reason).not
            else {
                return nil
            }
            return { submitHandler(reason) }
        }

        let inspection = SelfInspection()
        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: .grid(9)) {
                    TitleSubtitleContentView(
                        "Please tell us why",
                        "Please tell us the reason why you decided to cancel your lesson plan:"
                    ) { padding in
                        ScrollView {
                            ChoiceList(
                                data: Reason.allCases,
                                id: \.self,
                                selection: $selectedReason,
                                content: \.title
                            )
                            .padding(.trailing, padding.trailing)
                        }
                        .padding(.leading, padding.leading)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)

                FloatingView {
                    RythmicoButton("Cancel Lesson Plan", style: .secondary(), action: submitButtonAction ?? {})
                }
                .disabled(submitButtonAction == nil)
            }
            .accentColor(.rythmico.picoteeBlue)
            .testable(self)
            .animation(.rythmicoSpring(duration: .durationShort), value: submitButtonAction != nil)
            .onChange(of: selectedReason, perform: handleRearrangementNeededReason)
            .multiModal {
                $0.alert(isPresented: $isPresentingReschedulingAlert) { .reschedulingView(lessonPlan: lessonPlan) }
            }
            .interactiveDismissDisabled()
        }

        private func handleRearrangementNeededReason(_ reason: Reason?) {
            guard reason == .rearrangementNeeded else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                isPresentingReschedulingAlert = true
            }
        }
    }
}

private extension LessonPlan.CancellationInfo.Reason {
    var title: String {
        switch self {
        case .tooExpensive:
            return "Price"
        case .badTutor:
            return "Tutor wasn’t the right fit"
        case .rearrangementNeeded:
            return "I want to rearrange the plan"
        case .other:
            return "Other"
        }
    }
}

#if DEBUG
struct LessonPlanCancellationReasonView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanCancellationView.ReasonView(lessonPlan: .pendingJackGuitarPlanStub) { _ in }
    }
}
#endif
