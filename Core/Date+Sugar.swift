import Foundation
import FoundationSugar
import Then

extension Date {
    init?(date: Date, time: Date) {
        let calendar = Current.calendar()

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)

        let mergedComponents = DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: timeComponents.hour,
            minute: timeComponents.minute,
            second: timeComponents.second
        )

        guard let _self = calendar.date(from: mergedComponents) else {
            return nil
        }

        self = _self
    }

    static func + (lhs: Date, rhs: (Int, Calendar.Component)) -> Date {
        let amount = rhs.0, units = rhs.1
        return Calendar.current.date(byAdding: units, value: amount, to: lhs) !! preconditionFailure(
            "Date addition failed in \(#file):\(#line)"
        )
    }

    static func - (lhs: Date, rhs: (Int, Calendar.Component)) -> Date {
        lhs + (-rhs.0, rhs.1)
    }
}

extension Calendar {
    func diff(from fromDate: Date, to toDate: Date, in unit: Calendar.Component) -> Int {
        dateComponents([unit], from: fromDate, to: toDate).value(for: unit)!
    }
}

extension Calendar: Then {}

extension Date: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = ISO8601DateFormatter().date(from: value)!
    }
}

extension Date {
    static var stub: Date {
        "2020-07-13T12:15:00Z"
    }

    static var referenceDate: Date {
        Date(timeIntervalSinceReferenceDate: .zero)
    }
}
