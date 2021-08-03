import SwiftUI

struct LessonScheduleView: View {
    var lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(2)) {
            RythmicoLabel(asset: Asset.Icon.Label.info, title: dateText)
            RythmicoLabel(asset: Asset.Icon.Label.time, title: timeText)
        }
        .lineLimit(1)
    }

    private var schedule: Schedule { lesson.schedule }

    private static let dateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private var dateText: Text {
        Self.dateFormatter.string(from: schedule.startDate).text.rythmicoFontWeight(.bodyMedium)
    }

    private static let timeFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    private var timeText: Text {
        Self.timeFormatter.string(from: schedule.startDate, to: schedule.endDate).text.rythmicoFontWeight(.bodyMedium)
    }
}

#if DEBUG
struct LessonScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        LessonScheduleView(lesson: .scheduledStub)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
