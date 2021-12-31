import FoundationEncore

extension Schedule {
    static let stub = Self(
        startDate: try! .stub + (6, .hour, .neutral),
        duration: .fortyFiveMinutes
    )

    static let startedYesterdayStub = Self(
        startDate: try! .stub - (1, .day, .neutral),
        duration: .fortyFiveMinutes
    )

    static let startingTomorrowStub = Self(
        startDate: try! .stub + (1, .day, .neutral),
        duration: .fortyFiveMinutes
    )

    static let startingIn3DaysStub = Self(
        startDate: try! .stub + (3, .day, .neutral),
        duration: .oneHour
    )

    static let startingIn1WeekStub = Self(
        startDate: try! .stub + (1, .weekOfYear, .neutral),
        duration: .oneHour
    )
}
