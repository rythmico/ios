import Foundation

struct Schedule: Equatable {
    var startDate: Date
    var duration: Duration
}

enum Duration: Int, Equatable, PickableOption {
    case fortyFiveMinutes = 45
    case oneHour = 60
    case oneHourThirtyMinutes = 90

    var title: String { "\(rawValue) minutes" }
}
