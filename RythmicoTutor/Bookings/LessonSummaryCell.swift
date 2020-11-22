import SwiftUI
import Sugar

struct LessonSummaryCell: View {
    var lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LessonSummaryCellMainContent(lesson: lesson)
        }
        .disabled(lesson.status.isSkipped)
    }
}

struct LessonSummaryCellMainContent: View {
    var lesson: Lesson

    @ObservedObject
    private var state = Current.state

    var title: String {
        [lesson.student.name.firstWord, "\(lesson.instrument.name) Lesson \(lesson.number)"]
            .compact()
            .joined(separator: " - ")
    }

    var subtitle: String {
        switch lesson.status {
        case .scheduled, .completed:
            return durationText
        case .skipped:
            return [durationText, "Skipped"].joined(separator: " • ")
        }
    }

    var body: some View {
        NavigationLink(
            destination: Text(""),
            tag: lesson,
            selection: .constant(nil)
        ) {
            HStack(spacing: .spacingMedium) {
                VStack(alignment: .leading, spacing: .spacingUnit / 2) {
                    Text(title)
                        .foregroundColor(.primary)
                        .font(.body)
                    Text(subtitle)
                        .foregroundColor(.secondary)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, .spacingUnit)
        }
    }

    private let durationFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    private var durationText: String { durationFormatter.string(from: lesson.schedule.startDate, to: lesson.schedule.endDate) }
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
