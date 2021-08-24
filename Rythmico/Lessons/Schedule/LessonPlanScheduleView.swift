import SwiftUIEncore

struct LessonPlanScheduleView: View {
    let schedule: Schedule

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(2)) {
            RythmicoLabel(asset: Asset.Icon.Label.info, title: dateText)
            RythmicoLabel(asset: Asset.Icon.Label.time, title: timeText)
        }
        .lineLimit(1)
    }

    private var isFuture: Bool { Current.date() < schedule.startDate }

    private static let dayOfWeekFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private static let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private var dayOfWeek: String { Self.dayOfWeekFormatter.string(from: schedule.startDate) }
    private var date: String { Self.dateFormatter.string(from: schedule.startDate) }
    @BasicTextBuilder
    private var dateText: Text {
        "Every "
        dayOfWeek.text.rythmicoFontWeight(.bodyMedium)
        if isFuture {
            ", starting "
            date.text.rythmicoFontWeight(.bodyMedium)
        }
    }

    private static let timeFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    private var time: String { Self.timeFormatter.string(from: schedule.startDate, to: schedule.endDate) }
    @BasicTextBuilder
    private var timeText: Text {
        Text(time).rythmicoFontWeight(.bodyMedium)
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
