#if RYTHMICO
import StudentDTO
#elseif TUTOR
import TutorDTO
#endif

extension LessonPlanRequestSchedule {
    static let stub = Self(
        start: .stub,
        time: try! .stub + (6, .hour),
        duration: "PT45M"
    )

    static let startedYesterdayStub = Self(
        start: try! .stub - (1, .day),
        time: .stub,
        duration: "PT45M"
    )

    static let startingTomorrowStub = Self(
        start: try! .stub + (1, .day),
        time: .stub,
        duration: "PT45M"
    )

    static let startingIn3DaysStub = Self(
        start: try! .stub + (3, .day),
        time: .stub,
        duration: "PT60M"
    )

    static let startingIn1WeekStub = Self(
        start: try! .stub + (1, .weekOfYear),
        time: .stub,
        duration: "PT60M"
    )
}
