import SwiftUI
import FoundationSugar

struct LessonPlanResumingContentView: View {
    var option: LessonPlan.Options.Resume

    var body: some View {
        VStack(spacing: .spacingMedium) {
            descriptionText("This will resume the lesson plan, including upcoming lessons. The recurring payment will also be resumed.")
            InfoBanner(text:
                """
                When resuming a lesson plan, all your upcoming lessons will be resumed, except for any lessons occurring within the next \(cutoffString).

                We do this to protect Rythmico Tutors.
                """
            )
        }
    }

    @ViewBuilder
    private func descriptionText(_ string: String) -> some View {
        Text(string)
            .foregroundColor(.rythmicoGray90)
            .rythmicoTextStyle(.body)
            .frame(maxWidth: .spacingMax, alignment: .leading)
    }

    private static let formatter = Current.dateComponentsFormatter(allowedUnits: [.day, .hour, .minute], style: .full)
    private var cutoffString: String { Self.formatter.string(from: option.allOutside) !! preconditionFailure("nil for input '\(option.allOutside)'") }
}

#if DEBUG
struct LessonPlanResumingContentView_Preview: PreviewProvider {
    static var previews: some View {
        LessonPlanResumingContentView(option: .stub)
            .padding(.spacingMedium)
    }
}
#endif
