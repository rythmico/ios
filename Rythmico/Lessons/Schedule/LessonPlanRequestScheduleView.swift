import StudentDO
import SwiftUIEncore

struct LessonPlanRequestScheduleView: View {
    let schedule: LessonPlanRequestSchedule

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(2)) {
            RythmicoLabel(asset: Asset.Icon.Label.info, title: dateText)
            RythmicoLabel(asset: Asset.Icon.Label.time, title: timeText)
        }
        .lineLimit(1)
    }

    private var isFuture: Bool { Current.dateOnly() < schedule.start }

    private var dayOfWeek: String { schedule.start.formatted(custom: "EEEE", locale: Current.locale()) }
    private var date: String { schedule.start.formatted(custom: "d MMMM", locale: Current.locale()) }
    @BasicTextBuilder
    private var dateText: Text {
        "Every "
        dayOfWeek.text.rythmicoFontWeight(.bodyMedium)
        if isFuture {
            ", starting "
            date.text.rythmicoFontWeight(.bodyMedium)
        }
    }

    private var time: String { schedule.timeInterval.formatted(style: .short, locale: Current.locale()) }
    @BasicTextBuilder
    private var timeText: Text {
        Text(time).rythmicoFontWeight(.bodyMedium)
    }
}

#if DEBUG
struct LessonPlanRequestScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanRequestScheduleView(schedule: .startedYesterdayStub)
            LessonPlanRequestScheduleView(schedule: .startingIn3DaysStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
