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
                        Button("No", action: noAction).secondaryStyle()
                        Button("Yes", action: yesAction).tertiaryStyle()
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
                MultiStyleText(
                    parts: ["This lesson plan request is currently pending. By cancelling it, tutors won't be able to view it."],
                    foregroundColor: .rythmicoGray90
                )
            case .reviewing:
                MultiStyleText(
                    parts: ["This lesson plan request is currently in review. By cancelling it, tutors who have applied will be withdrawn."],
                    foregroundColor: .rythmicoGray90
                )
            case .scheduled:
                MultiStyleText(
                    parts: ["This will cancel the whole lesson plan, including upcoming lessons. The recurring payment will also be cancelled."],
                    foregroundColor: .rythmicoGray90
                )
                if !isFree {
                    MultiStyleText(
                        parts: ["You will still be charged the full amount for your upcoming lesson on this plan."],
                        foregroundColor: .rythmicoGray90
                    )
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
