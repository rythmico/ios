import SwiftUI
import FoundationSugar

struct LessonPlanResumingContentView: View {
    var lessonResumingCutoff: DateComponents

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

    private static let cutoffFormatter = Current.dateComponentsFormatter(allowedUnits: [.day, .hour, .minute], style: .full)
    private var cutoffString: String {
        Self.cutoffFormatter.string(from: lessonResumingCutoff) !! preconditionFailure(
            "cutoffFormatter returned nil for input 'from' \(lessonResumingCutoff)"
        )
    }
}

#if DEBUG
struct LessonPlanResumingContentView_Preview: PreviewProvider {
    static var previews: some View {
        LessonPlanResumingContentView(lessonResumingCutoff: .init(hour: 12))
            .padding(.spacingMedium)
    }
}
#endif
