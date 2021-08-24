import SwiftUIEncore

struct LessonPlanPausingContentView: View {
    var isFree: Bool
    var policy: LessonPlan.Options.Pause.Policy

    var body: some View {
        VStack(spacing: .grid(5)) {
            descriptionText("This will pause the entire lesson plan, including upcoming lessons. The recurring payment will also be paused.")
            if !isFree {
                descriptionText("You will still be charged the full amount for your upcoming lesson on this plan.")
                InfoBanner(text:
                    """
                    When pausing a lesson plan, you will still be charged the full amount for an upcoming lesson if the plan is paused less than \(cutoffString) before the lesson is scheduled to start.

                    We do this to protect Rythmico Tutors.
                    """
                )
            }
        }
    }

    @ViewBuilder
    private func descriptionText(_ string: String) -> some View {
        Text(string)
            .foregroundColor(.rythmico.foreground)
            .rythmicoTextStyle(.body)
            .frame(maxWidth: .grid(.max), alignment: .leading)
    }

    private static let formatter = Current.dateComponentsFormatter(allowedUnits: [.hour, .minute], style: .full)
    private var cutoffString: String { Self.formatter.string(from: policy.freeBeforePeriod) !! preconditionFailure("nil for input '\(policy.freeBeforePeriod)'") }
}

#if DEBUG
struct LessonPlanPausingContentView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanPausingContentView(isFree: true, policy: .stub)
            LessonPlanPausingContentView(isFree: false, policy: .stub)
        }
        .padding(.grid(5))
    }
}
#endif
