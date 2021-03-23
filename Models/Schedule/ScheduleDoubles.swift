import Foundation
import FoundationSugar
import Then

extension Schedule: Then {}

extension Schedule {
    static let stub = Self(
        startDate: .stub + (6, .hour, .current),
        duration: .fortyFiveMinutes
    )

    static let startingTomorrowStub = Self(
        startDate: .stub + (1, .day, .current),
        duration: .fortyFiveMinutes
    )

    static let startingIn3DaysStub = Self(
        startDate: .stub + (3, .day, .current),
        duration: .oneHour
    )

    static let startingIn1WeekStub = Self(
        startDate: .stub + (1, .weekOfMonth, .current),
        duration: .oneHour
    )
}
