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
            LessonPlanScheduleView(schedule: schedule)
                .foregroundColor(.rythmico.gray90)

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
}

#if DEBUG
struct ScheduleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanRequestedScheduleView(.startedYesterdayStub, tutor: .none)
            LessonPlanRequestedScheduleView(.startingTomorrowStub, tutor: .davidStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
