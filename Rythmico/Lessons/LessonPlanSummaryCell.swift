import SwiftUI

struct LessonPlanSummaryCell: View {
    var lessonPlan: LessonPlan

    var title: String {
        [
            lessonPlan.student.name.firstWord,
            "\(lessonPlan.instrument.name) Lessons"
        ].compactMap { $0 }.joined(separator: " - ")
    }

    var subtitle: String {
        switch lessonPlan.status {
        case .pending:
            return "Pending tutor applications"
        default:
            return "" // TODO
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .rythmicoFont(.subheadlineBold)
                    .foregroundColor(.rythmicoForeground)
                Text(subtitle)
                    .rythmicoFont(.body)
                    .foregroundColor(.rythmicoGray90)
                HStack(spacing: .spacingExtraSmall) {
                    LessonPlanTutorStatusView(lessonPlan.status, summarized: true)
                    LessonPlanStatusPill(lessonPlan.status)
                }
            }
        }
        .padding(.spacingMedium)
        .modifier(RoundedShadowContainer())
    }
}
