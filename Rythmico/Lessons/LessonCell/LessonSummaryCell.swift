import SwiftUI
import FoundationSugar

struct LessonSummaryCell: View {
    var lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LessonSummaryCellMainContent(lesson: lesson)
        }
        .modifier(RoundedShadowContainer())
        .disabled(lesson.status.isSkipped)
    }
}

struct LessonSummaryCellMainContent: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    var lesson: Lesson

    var subtitle: String {
        switch lesson.status {
        case .scheduled:
            return [startDateText, durationText].joined(separator: " • ")
        case .paused:
            return [startDateText, "Lesson Plan Paused"].joined(separator: " • ")
        case .skipped:
            return [startDateText, "Lesson Skipped"].joined(separator: " • ")
        case .completed:
            return [startDateText, "Lesson Complete"].joined(separator: " • ")
        }
    }

    var body: some View {
        Button(action: { navigator.go(to: LessonDetailScreen(lesson: lesson), on: currentScreen) }) {
            VStack(alignment: .leading, spacing: 0) {
                Text(lesson.title)
                    .foregroundColor(lesson.status.isSkipped ? .rythmicoGray90 : .rythmicoForeground)
                    .rythmicoTextStyle(.subheadlineBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                VSpacing(.spacingUnit * 2)
                Text(subtitle)
                    .rythmicoTextStyle(.body)
                    .foregroundColor(.rythmicoGray90)
                VSpacing(.spacingExtraSmall)
                HStack(spacing: .spacingExtraSmall) {
                    InlineContentAndTitleView(lesson: lesson)
                    Pill(status: lesson.status)
                }
            }
            .padding(.spacingMedium)
        }
    }

    private static let startDateFormatter = Current.dateFormatter(format: .custom("d MMM"))
    private var startDateText: String { Self.startDateFormatter.string(from: lesson.schedule.startDate) }

    private static let durationFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    private var durationText: String { Self.durationFormatter.string(from: lesson.schedule.startDate, to: lesson.schedule.endDate) }
}

#if DEBUG
struct LessonSummaryCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonSummaryCell(lesson: .scheduledStub)
            LessonSummaryCell(lesson: .skippedStub)
            LessonSummaryCell(lesson: .completedStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
