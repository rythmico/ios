import Foundation

extension Schedule.Duration: CasePickable {
    static var pickableCases: [Self] {
        [
            .fortyFiveMinutes,
            .oneHour,
            .oneHourThirtyMinutes
        ]
    }
}