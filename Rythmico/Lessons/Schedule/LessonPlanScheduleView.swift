import SwiftUI

struct LessonPlanScheduleView: View {
    var lessonPlan: LessonPlan

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingMedium) {
            label(icon: Asset.iconInfo, title: dateText)
            label(icon: Asset.iconTime, title: timeText)
        }
    }

    @ViewBuilder
    private func label(icon: ImageAsset, title: String) -> some View {
        HStack(spacing: .spacingUnit * 2) {
            Image(decorative: icon.name).renderingMode(.template)
            Text(title)
                .rythmicoTextStyle(.body)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private var schedule: Schedule { lessonPlan.schedule }
    private var dateText: String { "Every " + Self.dateFormatter.string(from: schedule.startDate) }
    private var timeText: String { Self.timeFormatter.string(from: schedule.startDate, to: schedule.endDate) }

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
