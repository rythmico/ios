import SwiftUI
import FoundationSugar

struct LessonPlanPausingContentView: View {
    var isFree: Bool
    var freePauseUntil: Date

    var body: some View {
        VStack(spacing: .spacingMedium) {
            descriptionText("This will pause the entire lesson plan, including upcoming lessons. The recurring payment will also be paused.")
            if !isFree {
                descriptionText("You will still be charged the full amount for your upcoming lesson on this plan.")
                InfoBanner(text:
                    """
                    When pausing a lesson plan, you will still be charged the full amount for an upcoming lesson if the plan is paused less than 3 hours before the lesson is scheduled to start.

                    We do this to protect Rythmico Tutors.
                    """
                )
            }
        }
    }

    @ViewBuilder
    private func descriptionText(_ string: String) -> some View {
        Text(string)
            .foregroundColor(.rythmicoGray90)
            .rythmicoTextStyle(.body)
            .frame(maxWidth: .spacingMax, alignment: .leading)
    }
}

#if DEBUG
struct LessonPlanPausingContentView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanPausingContentView(isFree: true, freePauseUntil: Current.date() - (24, .hour))
            LessonPlanPausingContentView(isFree: false, freePauseUntil: Current.date() - (3, .hour))
        }
        .padding(.spacingMedium)
    }
}
#endif
