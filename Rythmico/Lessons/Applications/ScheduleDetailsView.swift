import SwiftUI

struct ScheduleDetailsView: View {
    var schedule: Schedule
    var tutor: LessonPlan.Tutor?

    init(_ schedule: Schedule, tutor: LessonPlan.Tutor?) {
        self.schedule = schedule
        self.tutor = tutor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingSmall) {
            HStack(spacing: .spacingExtraSmall) {
                Image(decorative: Asset.iconInfo.name)
                    .renderingMode(.template)
                    .foregroundColor(.rythmicoGray90)
                MultiStyleText(parts: [
                    "Start Date: ".color(.rythmicoGray90),
                    startDateText.color(.rythmicoGray90).style(.bodyBold)
                ])
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: .spacingExtraSmall) {
                Image(decorative: Asset.iconTime.name)
                    .renderingMode(.template)
                    .foregroundColor(.rythmicoGray90)
                MultiStyleText(parts: startTimeAndDurationText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: .spacingExtraSmall) {
                Image(decorative: Asset.iconTime.name).hidden()
                MultiStyleText(parts: frequencyText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let tutor = tutor {
                HStack(spacing: .spacingExtraSmall) {
                    Image(decorative: Asset.iconTime.name).hidden()
                    HStack(spacing: .spacingExtraSmall) {
                        LessonPlanTutorAvatarView(tutor, mode: .thumbnail).fixedSize()
                        TutorAcceptedStatusPill(tutor: tutor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private let startDateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private var startDateText: String { startDateFormatter.string(from: schedule.startDate) }

    private let startTimeFormatter = Current.dateFormatter(format: .custom("h:mma"))
    private var startTimeText: String { startTimeFormatter.string(from: schedule.startDate) }
    private var startTimeAndDurationText: [MultiStyleText.Part] {
        startTimeText.style(.bodyBold).color(.rythmicoGray90) +
        " for ".color(.rythmicoGray90) +
        "\(schedule.duration.rawValue) minutes".style(.bodyBold).color(.rythmicoGray90)
    }

    private let frequencyDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private var frequencyDayText: String { frequencyDayFormatter.string(from: schedule.startDate) }
    private var frequencyText: [MultiStyleText.Part] {
        "Reocurring ".color(.rythmicoGray90) +
        "every \(frequencyDayText)".style(.bodyBold).color(.rythmicoGray90) +
        " at the same time and for the same duration".color(.rythmicoGray90)
    }
}

struct ScheduleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScheduleDetailsView(.stub, tutor: .none)
            ScheduleDetailsView(.stub, tutor: .davidStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
