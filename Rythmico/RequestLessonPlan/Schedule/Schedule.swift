import Foundation

struct Schedule: Equatable {
    var startDate: Date
    var duration: Duration
}

enum Duration: Int, Equatable, CasePickable, CaseIterable {
    // NOTE: do not EVER remove any existing cases.
    // To modify picker options, instead explicitly specify
    // which cases you want to show on a picker by declaring
    // `static var pickableCases: [Duration] { [...] }`
    case fortyFiveMinutes = 45
    case oneHour = 60
    case oneHourThirtyMinutes = 90
}
