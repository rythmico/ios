import SwiftUISugar

struct LessonPlanScheduleView: View {
    let schedule: Schedule

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(2)) {
            RythmicoLabel(icon: { Image.calendarIcon }, title: { dateText })
            RythmicoLabel(asset: Asset.Icon.Label.time, title: { timeText })
        }
    }

    private var isFuture: Bool { Current.date() < schedule.startDate }

    private static let dayOfWeekFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private static let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private var dayOfWeek: String { Self.dayOfWeekFormatter.string(from: schedule.startDate) }
    private var date: String { Self.dateFormatter.string(from: schedule.startDate) }
    private var dateText: some View {
        Text {
            "Every "
            dayOfWeek.text.rythmicoFontWeight(.bodyMedium)
            if isFuture {
                ", starting "
                date.text.rythmicoFontWeight(.bodyMedium)
            }
        }
        .rythmicoTextStyle(.body)
    }

    private static let timeFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    private var time: String { Self.timeFormatter.string(from: schedule.startDate, to: schedule.endDate) }
    private var timeText: some View {
        Text(time).rythmicoTextStyle(.bodyMedium)
    }
}

#if DEBUG
struct LessonPlanScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanScheduleView(schedule: .startedYesterdayStub)
            LessonPlanScheduleView(schedule: .startingIn3DaysStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
