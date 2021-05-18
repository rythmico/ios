import SwiftUI
import TextBuilder

struct LessonPlanScheduleView: View {
    var lessonPlan: LessonPlan

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingMedium) {
            label(icon: Asset.Icon.Label.info, title: dateText)
            label(icon: Asset.Icon.Label.time, title: timeText)
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

    private var schedule: Schedule { lessonPlan.schedule }
    @SpacedTextBuilder
    private var dateText: Text {
        "Every"
        Self.dateFormatter.string(from: schedule.startDate).text.rythmicoFontWeight(.bodyBold)
    }
    private var timeText: Text {
        Self.timeFormatter.string(from: schedule.startDate, to: schedule.endDate).text.rythmicoFontWeight(.bodyBold)
    }

    private static let dateFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private static let timeFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
}

#if DEBUG
struct LessonPlanScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanScheduleView(lessonPlan: .jesseDrumsPlanStub)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
