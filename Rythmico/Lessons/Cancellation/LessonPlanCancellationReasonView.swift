import SwiftUI
import FoundationSugar

extension LessonPlanCancellationView {
    struct ReasonView: View, TestableView {
        typealias Reason = LessonPlan.CancellationInfo.Reason

        private var submitHandler: Handler<Reason>

        init(submitHandler: @escaping Handler<Reason>) {
            self.submitHandler = submitHandler
        }

        @State
        var selectedReason: Reason?

        var submitButtonAction: Action? {
            selectedReason.map { reason in
                { submitHandler(reason) }
            }
        }

        let inspection = SelfInspection()
        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: .spacingUnit * 9) {
                    TitleSubtitleView(
                        title: "Please tell us why",
                        subtitle: "Please tell us the reason why you decided to cancel your lesson plan:"
                    )
                    .padding(.horizontal, .spacingMedium)

                    SelectableList(Reason.allCases, title: \.title, selection: $selectedReason)
                }
                .frame(maxHeight: .infinity, alignment: .top)

                submitButtonAction.map { action in
                    FloatingView {
                        Button("Cancel Lesson Plan", action: action).secondaryStyle()
                    }
                }
            }
            .accentColor(.rythmicoPurple)
            .testable(self)
            .animation(.rythmicoSpring(duration: .durationShort), value: submitButtonAction != nil)
            .sheetInteractiveDismissal(false)
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
        LessonPlanCancellationView.ReasonView { _ in }
    }
}
#endif
