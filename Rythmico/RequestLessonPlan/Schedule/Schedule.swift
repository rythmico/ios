import Foundation

struct Schedule: Equatable {
    var startDate: Date
    var duration: Duration
}

struct PickableDate: PickableOption {
    var date: Date
    var format: String

    var optionTitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

enum Duration: Int, Equatable, CaseIterable, PickableOption {
    case fortyFiveMinutes = 45
    case oneHour = 60
    case oneHourThirtyMinutes = 90

    var optionTitle: String { "\(rawValue) minutes" }
}
