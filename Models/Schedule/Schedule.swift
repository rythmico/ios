import Foundation
import Tagged

struct Schedule: Equatable, Codable, Hashable {
    typealias Duration = Tagged<Self, Int>

    var startDate: Date
    var duration: Duration
}

extension Schedule {
    var endDate: Date {
        Current.calendar().date(byAdding: .minute, value: duration.rawValue, to: startDate)!
    }
}

extension Schedule.Duration {
    static let fortyFiveMinutes = Self(rawValue: 45)
    static let oneHour = Self(rawValue: 60)
    static let oneHourThirtyMinutes = Self(rawValue: 90)
}
