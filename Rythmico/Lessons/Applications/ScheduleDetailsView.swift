import SwiftUI

struct ScheduleDetailsView: View {
    var schedule: Schedule
    var tutor: Tutor?

    init(_ schedule: Schedule, tutor: Tutor?) {
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

            HStack(spacing: .spacingExtraSmall) {
                Image(decorative: Asset.iconTime.name)
                    .renderingMode(.template)
                    .foregroundColor(.rythmicoGray90)
                MultiStyleText(parts: startTimeAndDurationText)
            }

            HStack(spacing: .spacingExtraSmall) {
                Image(decorative: Asset.iconTime.name).hidden()
                MultiStyleText(parts: frequencyText)
            }

            if let tutor = tutor {
                HStack(spacing: .spacingExtraSmall) {
                    Image(decorative: Asset.iconTime.name).hidden()
                    HStack(spacing: .spacingExtraSmall) {
                        TutorAvatarView(tutor, mode: .thumbnail).fixedSize()
                        TutorAcceptedStatusPill(tutor: tutor)
                    }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    private static let startDateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private var startDateText: String { Self.startDateFormatter.string(from: schedule.startDate) }

    private static let startTimeFormatter = Current.dateFormatter(format: .custom("h:mma"))
    private var startTimeText: String { Self.startTimeFormatter.string(from: schedule.startDate) }
    private var startTimeAndDurationText: [MultiStyleText.Part] {
        startTimeText.style(.bodyBold).color(.rythmicoGray90) +
        " for ".color(.rythmicoGray90) +
        "\(schedule.duration.rawValue) minutes".style(.bodyBold).color(.rythmicoGray90)
    }

    private static let frequencyDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private var frequencyDayText: String { Self.frequencyDayFormatter.string(from: schedule.startDate) }
    private var frequencyText: [MultiStyleText.Part] {
        "Recurring ".color(.rythmicoGray90) +
        "every \(frequencyDayText)".style(.bodyBold).color(.rythmicoGray90) +
        " at the same time and for the same duration".color(.rythmicoGray90)
    }
}

#if DEBUG
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
#endif
