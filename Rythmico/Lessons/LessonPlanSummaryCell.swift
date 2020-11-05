import SwiftUI
import Sugar

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

    @ObservedObject
    private var state = Current.state

    var title: String {
        [
            lessonPlan.student.name.firstWord,
            "\(lessonPlan.instrument.name) Lessons"
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
        NavigationLink(
            destination: LessonPlanDetailView(lessonPlan: lessonPlan),
            tag: lessonPlan,
            selection: $state.lessonsContext.selectedLessonPlan
        ) {
            VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .rythmicoFont(.subheadlineBold)
                    .foregroundColor(lessonPlan.status.isCancelled ? .rythmicoGray90 : .rythmicoForeground)
                Text(subtitle)
                    .rythmicoFont(.body)
                    .foregroundColor(.rythmicoGray90)
                HStack(spacing: .spacingExtraSmall) {
                    LessonPlanTutorStatusView(lessonPlan.status, summarized: true)
                    Pill(status: lessonPlan.status)
                }
            }
            .padding(.spacingMedium)
        }
    }

    private let startDateFormatter = Current.dateFormatter(format: .custom("d MMM"))
    private var startDateText: String { startDateFormatter.string(from: lessonPlan.schedule.startDate) }
}

struct LessonPlanSummaryCellAccessory: View {
    var lessonPlan: LessonPlan

    @ObservedObject
    private var state = Current.state

    var body: some View {
        if let applicationsView = LessonPlanApplicationsView(lessonPlan) {
            Divider().overlay(Color.rythmicoGray20)

            NavigationLink(
                destination: applicationsView,
                tag: lessonPlan,
                selection: $state.lessonsContext.reviewingLessonPlan
            ) {
                HStack(spacing: .spacingExtraSmall) {
                    Text("Review Tutors")
                        .rythmicoFont(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemSymbol: .chevronRight)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                }
                .padding(.spacingMedium)
                .foregroundColor(.rythmicoGray90)
            }
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
