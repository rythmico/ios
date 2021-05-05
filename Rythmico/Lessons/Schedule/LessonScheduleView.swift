import SwiftUI

struct LessonScheduleView: View {
    var lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingMedium) {
            label(icon: Asset.iconInfo, title: dateText)
            label(icon: Asset.iconTime, title: timeText)
        }
    }

    @ViewBuilder
    private func label(icon: ImageAsset, title: Text) -> some View {
        HStack(spacing: .spacingUnit * 2) {
            Image(decorative: icon.name).renderingMode(.template)
            title
                .rythmicoTextStyle(.body)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private var schedule: Schedule { lesson.schedule }
    private var dateText: Text {
        Self.dateFormatter.string(from: schedule.startDate).text.rythmicoFontWeight(.bodyBold)
    }
    private var timeText: Text {
        Self.timeFormatter.string(from: schedule.startDate, to: schedule.endDate).text.rythmicoFontWeight(.bodyBold)
    }

    private static let dateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private static let timeFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
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
