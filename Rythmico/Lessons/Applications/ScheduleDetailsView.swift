import SwiftUI
import TextBuilder

struct ScheduleDetailsView: View {
    var schedule: Schedule
    var tutor: Tutor?

    init(_ schedule: Schedule, tutor: Tutor?) {
        self.schedule = schedule
        self.tutor = tutor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingSmall) {
            Group {
                HStack(spacing: .spacingExtraSmall) {
                    Image(decorative: Asset.iconInfo.name).renderingMode(.template)
                    startDateText
                }
                HStack(spacing: .spacingExtraSmall) {
                    Image(decorative: Asset.iconTime.name).renderingMode(.template)
                    startTimeAndDurationText
                }
                HStack(spacing: .spacingExtraSmall) {
                    Image(decorative: Asset.iconTime.name).hidden()
                    frequencyText
                }
            }
            .foregroundColor(.rythmicoGray90)

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
        .lineSpacing(6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }

    private static let startDateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private var startDate: String { Self.startDateFormatter.string(from: schedule.startDate) }
    @SpacedTextBuilder
    private var startDateText: Text {
        "Start Date:".text.rythmicoFont(.body)
        startDate.text.rythmicoFont(.bodyBold)
    }

    private static let startTimeFormatter = Current.dateFormatter(format: .custom("h:mma"))
    private var startTime: String { Self.startTimeFormatter.string(from: schedule.startDate) }
    private var startTimeAndDurationText: Text {
        Text(separator: String.whitespace) {
            startTime
            "for".text.rythmicoFont(.body)
            schedule.duration.title
        }
        .rythmicoFont(.bodyBold)
    }

    private static let frequencyDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private var frequencyDay: String { Self.frequencyDayFormatter.string(from: schedule.startDate) }
    private var frequencyText: Text {
        Text(separator: String.whitespace) {
            "Recurring"
            "every \(frequencyDay)".text.rythmicoFont(.bodyBold)
            "at the same time and for the same duration"
        }
        .rythmicoFont(.body)
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
