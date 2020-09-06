#if DEBUG
import Foundation
import Sugar

extension Schedule {
    static var stub: Self {
        .init(
            startDate: .stub + (6, .hour),
            duration: .fortyFiveMinutes
        )
    }

    static var startingTomorrowStub: Self {
        .init(
            startDate: .stub + (1, .day),
            duration: .fortyFiveMinutes
        )
    }

    static var startingIn3DaysStub: Self {
        .init(
            startDate: .stub + (3, .day),
            duration: .oneHour
        )
    }

    static var startingIn1WeekStub: Self {
        .init(
            startDate: .stub + (1, .weekOfMonth),
            duration: .oneHour
        )
    }
}
#endif
