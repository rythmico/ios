import SwiftUI
import Sugar

extension LessonPlanCancellationView {
    struct PromptView: View {
        var noAction: Action
        var yesAction: Action

        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: .spacingExtraLarge) {
                    TitleContentView(title: "Cancel Lesson Plan?", content: content)
                }
                .padding(.horizontal, .spacingMedium)

                InteractiveBackground()

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
            MultiStyleText(
                parts: ["This will cancel the whole lesson plan, including upcoming lessons. The recurring payment will also be cancelled."],
                foregroundColor: .rythmicoGray90
            )
        }
    }
}

#if DEBUG
struct LessonPlanCancellationPromptView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanCancellationView.PromptView(noAction: {}, yesAction: {})
    }
}
#endif
