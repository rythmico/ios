import SwiftUI
import Sugar

extension LessonPlanCancellationView {
    struct PromptView: View {
        var noAction: Action
        var yesAction: Action

        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: .spacingExtraLarge) {
                    TitleSubtitleView(
                        title: "Cancel Lesson Plan?",
                        subtitle: ["Are you sure you want to cancel your lesson plan?".style(.bodyBold)]
                    )
                    Text("This will cancel the weekly payments to the tutor, and all upcoming lessons.")
                        .rythmicoFont(.body)
                        .foregroundColor(.rythmicoGray90)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
    }
}

#if DEBUG
struct LessonPlanCancellationPromptView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanCancellationView.PromptView(noAction: {}, yesAction: {})
    }
}
#endif
