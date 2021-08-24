import SwiftUIEncore

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
            if let tutor = tutor {
                HStack(spacing: .grid(3)) {
                    TutorAvatarView(tutor, mode: .thumbnail).fixedSize()
                    TutorAcceptedStatusPill(tutor: tutor)
                }
            }
        }
        .foregroundColor(.rythmico.foreground)
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
