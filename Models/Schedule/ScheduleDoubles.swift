import Foundation
import Sugar
import Then

extension Schedule: Then {}

extension Schedule {
    static let stub = Self(
        startDate: .stub + (6, .hour),
        duration: .fortyFiveMinutes
    )

    static let startingTomorrowStub = Self(
        startDate: .stub + (1, .day),
        duration: .fortyFiveMinutes
    )

    static let startingIn3DaysStub = Self(
        startDate: .stub + (3, .day),
        duration: .oneHour
    )

    static let startingIn1WeekStub = Self(
        startDate: .stub + (1, .weekOfMonth),
        duration: .oneHour
    )
}
