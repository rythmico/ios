import Foundation

struct Schedule: Equatable, Codable, Hashable {
    var startDate: Date
    var duration: Duration
}

enum Duration: Int, Equatable, Codable, CasePickable, CaseIterable, Hashable {
    // NOTE: do not EVER remove any existing cases.
    // To modify picker options, instead explicitly specify
    // which cases you want to show on a picker by declaring
    // `static var pickableCases: [Duration] { [...] }`
    case fortyFiveMinutes = 45
    case oneHour = 60
    case oneHourThirtyMinutes = 90
}

extension Duration: LosslessStringConvertible {
    init?(_ description: String) {
        guard let integer = Int(description) else {
            return nil
        }
        self.init(rawValue: integer)
    }

    var description: String { String(rawValue) }
}
