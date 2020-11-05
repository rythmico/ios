import SwiftUI
import Sugar

struct LessonSummaryCell: View {
    var lesson: Lesson
    var lessonNumber: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LessonSummaryCellMainContent(lesson: lesson, lessonNumber: lessonNumber)
        }
        .modifier(RoundedShadowContainer())
        .disabled(lesson.status.isCancelled)
    }
}

struct LessonSummaryCellMainContent: View {
    var lesson: Lesson
    var lessonNumber: Int

    @ObservedObject
    private var state = Current.state

    var title: String {
        [lesson.student.name.firstWord, "\(lesson.instrument.name) Lesson \(lessonNumber)"]
            .compact()
            .joined(separator: " - ")
    }

    var subtitle: String {
        switch lesson.status {
        case .scheduled:
            return [startDateText, durationText].joined(separator: " • ")
        case .cancelled:
            return [startDateText, "Lesson Cancelled"].joined(separator: " • ")
        case .completed:
            return [startDateText, "Lesson Complete"].joined(separator: " • ")
        }
    }

    var body: some View {
        NavigationLink(
            destination: LessonDetailView(lesson: lesson, lessonNumber: lessonNumber),
            tag: lesson,
            selection: $state.lessonsContext.viewingLesson
        ) {
            VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                Text(title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .rythmicoFont(.subheadlineBold)
                    .foregroundColor(lesson.status.isCancelled ? .rythmicoGray90 : .rythmicoForeground)
                Text(subtitle)
                    .rythmicoFont(.body)
                    .foregroundColor(.rythmicoGray90)
                HStack(spacing: .spacingExtraSmall) {
                    InlineContentAndTitleView(lesson: lesson, summarized: true)
                    Pill(status: lesson.status)
                }
            }
            .padding(.spacingMedium)
        }
    }

    private let startDateFormatter = Current.dateFormatter(format: .custom("d MMM"))
    private var startDateText: String { startDateFormatter.string(from: lesson.schedule.startDate) }

    private let durationFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    private var durationText: String { durationFormatter.string(from: lesson.schedule.startDate, to: lesson.schedule.endDate) }
}

#if DEBUG
struct LessonSummaryCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonSummaryCell(lesson: .scheduledStub, lessonNumber: 1)
            LessonSummaryCell(lesson: .cancelledStub, lessonNumber: 2)
            LessonSummaryCell(lesson: .completedStub, lessonNumber: 3)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
