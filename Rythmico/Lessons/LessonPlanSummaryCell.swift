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
        case .reviewing:
            return "Pending selection of tutor"
        case .scheduled:
            return ""
        case .cancelled:
            return [startDateText, "Plan Cancelled"].joined(separator: " • ")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink(destination: LessonPlanDetailView(lessonPlan)) {
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
                        LessonPlanStatusPill(lessonPlan.status)
                    }
                }
                .padding(.spacingMedium)
            }

            if let applicationsView = LessonPlanApplicationsView(lessonPlan) {
                Divider().overlay(Color.rythmicoGray20)

                NavigationLink(destination: applicationsView) {
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
        .modifier(RoundedShadowContainer())
        .disabled(lessonPlan.status.isCancelled)
    }

    private let startDateFormatter = Current.dateFormatter(format: .custom("d MMM"))
    private var startDateText: String { startDateFormatter.string(from: lessonPlan.schedule.startDate) }
}

#if DEBUG
struct LessonPlanSummaryCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanSummaryCell(lessonPlan: .pendingJackGuitarPlanStub)
            LessonPlanSummaryCell(lessonPlan: .reviewingJackGuitarPlanStub)
            LessonPlanSummaryCell(lessonPlan: .cancelledJackGuitarPlanStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
