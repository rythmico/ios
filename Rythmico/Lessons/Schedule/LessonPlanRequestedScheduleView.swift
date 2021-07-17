import SwiftUISugar

struct LessonPlanRequestedScheduleView: View {
    var schedule: Schedule
    var tutor: Tutor?

    init(_ schedule: Schedule, tutor: Tutor?) {
        self.schedule = schedule
        self.tutor = tutor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(4)) {
            Group {
                HStack(spacing: .grid(3)) {
                    Image(systemSymbol: .calendar).resizable().aspectRatio(contentMode: .fit).frame(width: 16)
                    dateText
                }
                HStack(spacing: .grid(3)) {
                    Image(decorative: Asset.Icon.Label.time.name).renderingMode(.template)
                    timeText
                }
            }
            .foregroundColor(.rythmicoGray90)

            if let tutor = tutor {
                HStack(spacing: .grid(3)) {
                    Image(decorative: Asset.Icon.Label.time.name).hidden()
                    HStack(spacing: .grid(3)) {
                        TutorAvatarView(tutor, mode: .thumbnail).fixedSize()
                        TutorAcceptedStatusPill(tutor: tutor)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }

    private static let dayOfWeekFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private static let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private var dayOfWeek: String { Self.dayOfWeekFormatter.string(from: schedule.startDate) }
    private var date: String { Self.dateFormatter.string(from: schedule.startDate) }
    private var dateText: some View {
        Text {
            "Every "
            dayOfWeek.text.rythmicoFontWeight(.bodyBold)
            ", starting "
            date.text.rythmicoFontWeight(.bodyBold)
        }
        .rythmicoTextStyle(.body)
    }

    private static let timeFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    private var time: String { Self.timeFormatter.string(from: schedule.startDate, to: schedule.endDate) }
    private var timeText: some View {
        Text(time).rythmicoTextStyle(.bodyBold)
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
