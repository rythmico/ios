import SwiftUI

struct LessonScheduleView: View {
    var lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(5)) {
            RythmicoLabel(icon: { Image.calendarIcon }, title: { dateText })
            RythmicoLabel(asset: Asset.Icon.Label.time, title: { timeText })
        }
    }

    private var schedule: Schedule { lesson.schedule }

    private static let dateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private var dateText: some View {
        Self.dateFormatter.string(from: schedule.startDate).text.rythmicoTextStyle(.bodyBold)
    }

    private static let timeFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    private var timeText: some View {
        Self.timeFormatter.string(from: schedule.startDate, to: schedule.endDate).text.rythmicoTextStyle(.bodyBold)
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
