import SwiftUI
import FoundationSugar

extension LessonPlanCancellationView {
    struct PromptView: View {
        var lessonPlan: LessonPlan
        var noAction: Action
        var yesAction: Action

        var body: some View {
            VStack(spacing: 0) {
                TitleContentView(title: title, titlePadding: .init(horizontal: .spacingMedium)) {
                    ScrollView {
                        VStack(spacing: .spacingMedium, content: content).padding(.horizontal, .spacingMedium)
                    }
                }

                FloatingView {
                    HStack(spacing: .spacingSmall) {
                        RythmicoButton("No", style: RythmicoButtonStyle.secondary(), action: noAction)
                        RythmicoButton("Yes", style: RythmicoButtonStyle.tertiary(), action: yesAction)
                    }
                }
            }
        }

        private var title: String {
            switch lessonPlan.status {
            case .pending, .reviewing:
                return "Cancel Lesson Plan Request?"
            case .scheduled:
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
            case .scheduled:
                descriptionText("This will cancel the whole lesson plan, including upcoming lessons. The recurring payment will also be cancelled.")
                if !isFree {
                    descriptionText("You will still be charged the full amount for your upcoming lesson on this plan.")
                    InfoBanner(text:
                        """
                        When cancelling a lesson plan, you will still be charged the full amount for an upcoming lesson if the plan is cancelled less than 3 hours before the lesson is scheduled to start.

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

        private var isFree: Bool {
            guard let freeSkipUntil = freeSkipUntil else { return true }
            return Current.date() < freeSkipUntil
        }

        private var freeSkipUntil: Date? {
            lessonPlan.lessons?.lazy.compactMap(\.freeSkipUntil).sorted(by: >).first
        }
    }
}

#if DEBUG
struct LessonPlanCancellationPromptView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanCancellationView.PromptView(
            lessonPlan: LessonPlan.pendingJackGuitarPlanStub.with {
                $0.status = .scheduled(
                    [
                        Lesson.scheduledStub.with(\.freeSkipUntil, Current.date() - (3, .second)),
                        Lesson.scheduledStub.with(\.freeSkipUntil, Current.date() - (2, .second)),
//                        Lesson.scheduledStub.with(\.freeSkipUntil, Current.date() + (2, .second)),
                        Lesson.scheduledStub.with(\.freeSkipUntil, Current.date() - (1, .second)),
                    ],
                    .jesseStub
                )
            },
            noAction: {},
            yesAction: {}
        )
    }
}
#endif
