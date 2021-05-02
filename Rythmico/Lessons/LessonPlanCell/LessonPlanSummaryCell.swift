import SwiftUI
import FoundationSugar

struct LessonPlanSummaryCell: View {
    var lessonPlan: LessonPlan

    init?(lessonPlan: LessonPlan) {
        switch lessonPlan.status {
        case .scheduled, .cancelled:
            return nil
        case .pending, .reviewing:
            break
        }
        self.lessonPlan = lessonPlan
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LessonPlanSummaryCellMainContent(lessonPlan: lessonPlan)
            LessonPlanSummaryCellAccessory(lessonPlan: lessonPlan)
        }
        .modifier(RoundedShadowContainer())
        .disabled(lessonPlan.status.isCancelled)
    }
}

struct LessonPlanSummaryCellMainContent: View {
    var lessonPlan: LessonPlan

    var title: String {
        [
            lessonPlan.student.name.firstWord,
            "\(lessonPlan.instrument.assimilatedName) Lessons"
        ].compact().joined(separator: " - ")
    }

    var subtitle: String {
        switch lessonPlan.status {
        case .pending:
            return "Pending tutor applications"
        case .reviewing:
            return "Pending selection of tutor"
        case .scheduled:
            return ""
        case .cancelled:
            return [startDateText, "Plan Cancelled"].joined(separator: " • ")
        }
    }

    var body: some View {
        Button(action: { Current.state.lessonsContext.viewingLessonPlan = lessonPlan }) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .rythmicoTextStyle(.subheadlineBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .foregroundColor(lessonPlan.status.isCancelled ? .rythmicoGray90 : .rythmicoForeground)
                VSpacing(.spacingUnit * 2)
                Text(subtitle)
                    .rythmicoTextStyle(.body)
                    .foregroundColor(.rythmicoGray90)
                VSpacing(.spacingExtraSmall)
                HStack(spacing: .spacingExtraSmall) {
                    LessonPlanTutorStatusView(status: lessonPlan.status, summarized: true)
                    Pill(lessonPlan: lessonPlan)
                }
            }
            .padding(.spacingMedium)
        }
    }

    private static let startDateFormatter = Current.dateFormatter(format: .custom("d MMM"))
    private var startDateText: String { Self.startDateFormatter.string(from: lessonPlan.schedule.startDate) }
}

struct LessonPlanSummaryCellAccessory: View {
    var lessonPlan: LessonPlan

    var body: some View {
        if lessonPlan.status.isReviewing {
            Divider().overlay(Color.rythmicoGray20)

            Button(action: { Current.state.lessonsContext.reviewingLessonPlan = lessonPlan }) {
                HStack(spacing: .spacingExtraSmall) {
                    Text("Choose Tutor")
                        .rythmicoTextStyle(.bodySemibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemSymbol: .chevronRight)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                }
                .padding(.spacingMedium)
                .foregroundColor(.rythmicoPurple)
            }
            .background(Color.rythmicoPurple.opacity(0.02))
        }
    }
}

#if DEBUG
struct LessonPlanSummaryCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanSummaryCell(lessonPlan: .pendingJackGuitarPlanStub)
            LessonPlanSummaryCell(lessonPlan: .reviewingJackGuitarPlanStub)
            LessonPlanSummaryCell(lessonPlan: .scheduledJackGuitarPlanStub)
            LessonPlanSummaryCell(lessonPlan: .cancelledJackGuitarPlanStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
