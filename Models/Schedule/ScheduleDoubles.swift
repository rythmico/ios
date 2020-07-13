import Foundation
import Sugar

extension Schedule {
    private static let startDate = Date()

    @available(*, deprecated, message: "Use a specific, date-pinned stub instead")
    static var stub: Schedule {
        .init(startDate: startDate, duration: .fortyFiveMinutes)
    }

    @available(*, deprecated, message: "Use AppEnvironment.dummy.date() instead")
    private static let now: Date = "2020-07-13T17:30:00Z"

    static var startingTomorrowStub: Schedule {
        Schedule(
            startDate: now + (1, .day),
            duration: .fortyFiveMinutes
        )
    }

    static var startingIn3DaysStub: Schedule {
        Schedule(
            startDate: now + (3, .day),
            duration: .oneHour
        )
    }

    static var startingIn1WeekStub: Schedule {
        Schedule(
            startDate: now + (1, .weekOfMonth),
            duration: .oneHour
        )
    }
}
