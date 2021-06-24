import SwiftUI
import FoundationSugar

extension LessonPlanCancellationView {
    struct PromptView: View {
        let lessonPlan: LessonPlan
        let policy: LessonPlan.Options.Cancel.Policy?
        let noAction: Action
        let yesAction: Action

        var body: some View {
            VStack(spacing: 0) {
                TitleContentView(title: title) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: .grid(5), content: content)
                            .frame(maxWidth: .grid(.max), alignment: .leading)
                            .padding(.horizontal, .grid(5))
                    }
                }

                FloatingActionMenu([
                    .init(title: "No", isPrimary: true, action: noAction),
                    .init(title: "Yes", action: yesAction),
                ])
            }
        }

        private var title: String {
            switch lessonPlan.status {
            case .pending, .reviewing:
                return "Cancel Lesson Plan Request?"
            case .active, .paused:
                return "Cancel Lesson Plan?"
            case .cancelled:
                preconditionFailure("Cannot cancel an already cancelled lesson plan.")
            }
        }

        @ViewBuilder
        private func content() -> some View {
            switch lessonPlan.status {
            case .pending:
                descriptionText("This lesson plan request is currently pending. By cancelling it, tutors won't be able to view it.")
            case .reviewing:
                descriptionText("This lesson plan request is currently in review. By cancelling it, tutors who have applied will be withdrawn.")
            case .paused:
                descriptionText("This will cancel the entire lesson plan.")
            case .active:
                descriptionText("This will cancel the entire lesson plan, including upcoming lessons. The recurring payment will also be cancelled.")
                if isFree == false, let cutoffString = cutoffString {
                    descriptionText("You will still be charged the full amount for your upcoming lesson on this plan.")
                    InfoBanner(text:
                        """
                        When cancelling a lesson plan, you will still be charged the full amount for an upcoming lesson if the plan is cancelled less than \(cutoffString) before the lesson is scheduled to start.

                        We do this to protect Rythmico Tutors.
                        """
                    )
                }
            case .cancelled:
                preconditionFailure("Cannot cancel an already cancelled lesson plan.")
            }
        }

        @ViewBuilder
        private func descriptionText(_ string: String) -> some View {
            Text(string)
                .foregroundColor(.rythmicoGray90)
                .rythmicoTextStyle(.body)
        }

        private var isFree: Bool? {
            guard let freeBefore = policy?.freeBeforeDate else { return nil }
            return Current.date() < freeBefore
        }

        private static let formatter = Current.dateComponentsFormatter(allowedUnits: [.hour, .minute], style: .full)
        private var cutoffString: String? {
            guard let freeWithin = policy?.freeBeforePeriod else { return nil }
            return Self.formatter.string(from: freeWithin) !! preconditionFailure("nil for input '\(freeWithin)'")
        }
    }
}

#if DEBUG
struct LessonPlanCancellationPromptView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanCancellationView.PromptView(
            lessonPlan: LessonPlan.activeJackGuitarPlanStub,
            policy: .stub,
            noAction: {},
            yesAction: {}
        )
    }
}
#endif
