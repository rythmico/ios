import SwiftUISugar

struct LessonSummaryCell: View {
    let lesson: Lesson

    var body: some View {
        Container(style: .outline(radius: .large)) {
            VStack(alignment: .leading, spacing: 0) {
                LessonSummaryCellMainContent(lesson: lesson)
            }
        }
    }
}

struct LessonSummaryCellMainContent: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lesson: Lesson

    var subtitle: String {
        switch lesson.status {
        case .scheduled:
            return [startDateText, durationText].joined(separator: " • ")
        case .completed:
            return [startDateText, "Lesson Complete"].joined(separator: " • ")
        case .skipped:
            return [startDateText, "Lesson Skipped"].joined(separator: " • ")
        case .paused:
            return [startDateText, "Plan Paused"].joined(separator: " • ")
        case .cancelled:
            return [startDateText, "Plan Cancelled"].joined(separator: " • ")
        }
    }

    var body: some View {
        Button(action: onTapAction ?? {}) {
            VStack(alignment: .leading, spacing: 0) {
                Text(lesson.title)
                    .foregroundColor(.rythmico.foreground)
                    .rythmicoTextStyle(.subheadlineBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .opacity(opacity)
                VSpacing(.grid(2))
                Text(subtitle)
                    .rythmicoTextStyle(.body)
                    .foregroundColor(.rythmico.foreground)
                    .opacity(opacity)
                VSpacing(.grid(3))
                HStack(spacing: .grid(3)) {
                    InlineContentAndTitleView(lesson: lesson).opacity(opacity)
                    Pill(status: lesson.status)
                }
            }
            .padding(.grid(5))
        }
    }

    private var onTapAction: Action? {
        LessonDetailScreen(lesson: lesson).map { lessonDetailScreen in
            { navigator.go(to: lessonDetailScreen, on: currentScreen) }
        }
    }

    private var opacity: Double { isDimmed ? 0.5 : 1 }
    private var isDimmed: Bool {
        switch lesson.status {
        case .scheduled, .completed: return false
        case .skipped, .paused, .cancelled: return true
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
            LessonSummaryCell(lesson: .completedStub)
            LessonSummaryCell(lesson: .skippedStub)
            LessonSummaryCell(lesson: .pausedStub)
            LessonSummaryCell(lesson: .cancelledStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
