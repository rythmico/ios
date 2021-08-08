import SwiftUISugar

extension LessonPlanCancellationView {
    struct ReasonView: View, TestableView {
        typealias Reason = LessonPlan.CancellationInfo.Reason

        var lessonPlan: LessonPlan
        var submitHandler: Handler<Reason>

        @State
        var selectedReason: Reason?
        @State
        private var isPresentingReschedulingAlert = false

        var submitButtonAction: Action? {
            guard let reason = selectedReason else { return nil }
            switch reason {
            case .rearrangementNeeded:
                return { isPresentingReschedulingAlert = true }
            case .noApplicants, .badApplicants, .tooExpensive, .badTutor, .other:
                return { submitHandler(reason) }
            }
        }

        let inspection = SelfInspection()
        var body: some View {
            VStack(spacing: 0) {
                TitleSubtitleContentView(
                    "Please tell us why",
                    "Please tell us the reason why you decided to cancel your lesson plan:",
                    spacing: .grid(8)
                ) { padding in
                    ScrollView {
                        ChoiceList(
                            data: reasons,
                            id: \.self,
                            selection: $selectedReason,
                            content: \.title
                        )
                        .padding(.trailing, padding.trailing)
                    }
                    .padding(.leading, padding.leading)
                }
                .frame(maxHeight: .infinity, alignment: .top)

                FloatingView {
                    RythmicoButton("Cancel Lesson Plan", style: .secondary(), action: submitButtonAction ?? {})
                }
                .disabled(submitButtonDisabled)
                .onTapGesture {
                    if submitButtonDisabled { submitButtonAction?() }
                }
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

        private var reasons: [Reason] {
            if lessonPlan.isRequest {
                return [
                    .noApplicants,
                    .badApplicants,
                    .rearrangementNeeded,
                    .other
                ]
            } else {
                return [
                    .tooExpensive,
                    .badTutor,
                    .rearrangementNeeded,
                    .other
                ]
            }
        }

        private func handleRearrangementNeededReason(_ reason: Reason?) {
            guard reason == .rearrangementNeeded else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isPresentingReschedulingAlert = true
            }
        }

        var submitButtonDisabled: Bool {
            selectedReason == .rearrangementNeeded
        }
    }
}

private extension LessonPlan.CancellationInfo.Reason {
    var title: String {
        switch self {
        case .noApplicants:
            return "Waited too long for applications"
        case .badApplicants:
            return "Didn't like tutors who applied"
        case .tooExpensive:
            return "Price"
        case .badTutor:
            return "Tutor wasn't the right fit"
        case .rearrangementNeeded:
            return "I want to reschedule the plan"
        case .other:
            return "Other"
        }
    }
}

#if DEBUG
struct LessonPlanCancellationReasonView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanCancellationView.ReasonView(lessonPlan: .pendingJackGuitarPlanStub) { _ in }
        LessonPlanCancellationView.ReasonView(lessonPlan: .reviewingJackGuitarPlanStub) { _ in }
        LessonPlanCancellationView.ReasonView(lessonPlan: .activeJackGuitarPlanStub) { _ in }
        LessonPlanCancellationView.ReasonView(lessonPlan: .pausedJackGuitarPlanStub) { _ in }
        LessonPlanCancellationView.ReasonView(lessonPlan: .cancelledJackGuitarPlanStub) { _ in }
    }
}
#endif
