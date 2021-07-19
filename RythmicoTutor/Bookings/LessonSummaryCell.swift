import SwiftUISugar

struct LessonSummaryCell: View {
    let lesson: Lesson

    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    var subtitle: String {
        switch lesson.status {
        case .scheduled, .completed:
            return durationText
        case .skipped:
            return [durationText, "Skipped"].joined(separator: " • ")
        case .paused:
            return [durationText, "Plan Paused"].joined(separator: " • ")
        case .cancelled:
            return [durationText, "Plan Cancelled"].joined(separator: " • ")
        }
    }

    var body: some View {
        if hasDetail {
            Button(action: goToDetail) { content }
        } else {
            content
        }
    }

    private var hasDetail: Bool {
        lesson.status.isScheduled
    }

    private func goToDetail() {
        navigator.go(to: LessonDetailScreen(lesson: lesson), on: currentScreen)
    }

    private var content: some View {
        HStack(spacing: .grid(5)) {
            VStack(alignment: .leading, spacing: .grid(0.5)) {
                Text(lesson.title)
                    .foregroundColor(.primary)
                    .font(.body)
                Text(subtitle)
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if lesson.status.isCompleted {
                Image(systemSymbol: .checkmark)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.accentColor)
            }
        }
        .cellAccessory(hasDetail ? .disclosure : .none)
        .padding(.vertical, .grid(1))
        .opacity(lesson.status.isSkipped ? 0.3 : 1)
    }

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
