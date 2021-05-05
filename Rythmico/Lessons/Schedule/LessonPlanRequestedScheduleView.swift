import SwiftUI
import TextBuilder

struct LessonPlanRequestedScheduleView: View {
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
                    timeText
                }
                HStack(spacing: .spacingExtraSmall) {
                    Image(systemSymbol: .calendar).resizable().aspectRatio(contentMode: .fit).frame(width: 16)
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }

    private static let startDateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private var startDate: String { Self.startDateFormatter.string(from: schedule.startDate) }
    private var startDateText: some View {
        Text(separator: .whitespace) {
            "Start Date:"
            startDate.text.rythmicoFontWeight(.bodyBold)
        }
        .rythmicoTextStyle(.body)
    }

    private static let timeFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    private var time: String { Self.timeFormatter.string(from: schedule.startDate, to: schedule.endDate) }
    private var timeText: some View {
        Text(time).rythmicoTextStyle(.bodyBold)
    }

    private static let frequencyDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private var frequencyDay: String { Self.frequencyDayFormatter.string(from: schedule.startDate) }
    private var frequencyText: some View {
        Text(separator: .whitespace) {
            "Recurring"
            "weekly".text.rythmicoFontWeight(.bodyBold)
        }
        .rythmicoTextStyle(.body)
    }
}

#if DEBUG
struct ScheduleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanRequestedScheduleView(.stub, tutor: .none)
            LessonPlanRequestedScheduleView(.stub, tutor: .davidStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
