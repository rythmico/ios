import StudentDTO
import SwiftUIEncore

struct LessonPlanRequestedScheduleAndTutorView: View {
    var schedule: LessonPlanRequestSchedule
    var tutor: Tutor?

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(4)) {
            LessonPlanRequestScheduleView(schedule: schedule)
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
struct LessonPlanRequestedScheduleAndTutorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanRequestedScheduleAndTutorView(schedule: .startedYesterdayStub, tutor: .none)
            LessonPlanRequestedScheduleAndTutorView(schedule: .startingTomorrowStub, tutor: .davidStub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
