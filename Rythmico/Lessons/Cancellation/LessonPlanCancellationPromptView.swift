import SwiftUI
import Sugar

extension LessonPlanCancellationView {
    struct PromptView: View {
        var lessonPlan: LessonPlan
        var noAction: Action
        var yesAction: Action

        var body: some View {
            VStack(spacing: 0) {
                TitleContentView(title: "Cancel Lesson Plan?", titlePadding: .init(horizontal: .spacingMedium), content: content)

                FloatingView {
                    HStack(spacing: .spacingSmall) {
                        Button("No", action: noAction).secondaryStyle()
                        Button("Yes", action: yesAction).tertiaryStyle()
                    }
                }
            }
        }

        @ViewBuilder
        private func content() -> some View {
            ScrollView {
                VStack(spacing: .spacingMedium) {
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
                }
                .padding(.horizontal, .spacingMedium)
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
