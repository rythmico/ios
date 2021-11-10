import StudentDTO

extension LessonPlanRequestSchedule {
    static let stub = Self(
        start: .stub,
        time: try! .stub + (6, .hour),
        duration: ValidDuration.fortyFiveMinutes
    )

    static let startedYesterdayStub = Self(
        start: try! .stub - (1, .day),
        time: .stub,
        duration: ValidDuration.fortyFiveMinutes
    )

    static let startingTomorrowStub = Self(
        start: try! .stub + (1, .day),
        time: .stub,
        duration: ValidDuration.fortyFiveMinutes
    )

    static let startingIn3DaysStub = Self(
        start: try! .stub + (3, .day),
        time: .stub,
        duration: ValidDuration.sixtyMinutes
    )

    static let startingIn1WeekStub = Self(
        start: try! .stub + (1, .weekOfYear),
        time: .stub,
        duration: ValidDuration.sixtyMinutes
    )
}
