import Foundation

extension Schedule {
    private static let startDate = Date()

    static var stub: Schedule {
        .init(startDate: startDate, duration: .fortyFiveMinutes)
    }
}
