import SwiftUI
import Sugar

extension LessonPlanCancellationView {
    struct ReasonView: View {
        typealias Reason = LessonPlan.CancellationInfo.Reason
        @State
        var selectedReason: Reason?
        var submitHandler: Handler<Reason>

        init(submitHandler: @escaping Handler<Reason>) {
            self.submitHandler = submitHandler
        }

        var submitButtonAction: Action? {
            selectedReason.map { reason in
                { self.submitHandler(reason) }
            }
        }

        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: .spacingUnit * 9) {
                    TitleSubtitleView(
                        title: "Please tell us why",
                        subtitle: "Please give us a reason why you decided to cancel your lesson plan"
                    )
                    .padding(.horizontal, .spacingMedium)

                    SelectableList(Reason.allCases, id: \.self, selection: $selectedReason) { reason in
                        Text(reason.title)
                            .foregroundColor(.rythmicoGray90)
                    }
                    .accentColor(.rythmicoPurple)
                }

                Spacer()

                submitButtonAction.map { action in
                    FloatingView {
                        Button("Submit", action: action).secondaryStyle()
                    }
                }
            }
            .betterSheetIsModalInPresentation(true)
        }
    }
}

private extension LessonPlan.CancellationInfo.Reason {
    var title: String {
        switch self {
        case .tooExpensive:
            return "Lesson price too expensive"
        case .badTutor:
            return "Tutor wasn’t very good"
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
