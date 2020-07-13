import Foundation

extension Date {
    public init?(date: Date, time: Date) {
        let calendar = Calendar.current

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

    public func adding(_ amount: Int, _ units: Calendar.Component) -> Date {
        guard let date = Calendar.current.date(byAdding: units, value: amount, to: self) else {
            preconditionFailure("Date addition failed in \(#file):\(#line)")
        }
        return date
    }

    public func subtracting(_ amount: Int, _ units: Calendar.Component) -> Date {
        adding(-amount, units)
    }

    public static func + (lhs: Date, rhs: (Int, Calendar.Component)) -> Date {
        lhs.adding(rhs.0, rhs.1)
    }

    public static func - (lhs: Date, rhs: (Int, Calendar.Component)) -> Date {
        lhs.subtracting(rhs.0, rhs.1)
    }

    public func setting(hour: Int, minute: Int = 0, second: Int = 0) -> Date {
        guard let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: self) else {
            preconditionFailure("Time setting failed in \(#file):\(#line)")
        }
        return date
    }
}

extension Date: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = ISO8601DateFormatter().date(from: value)!
    }
}

extension Array where Element == Date {
    public init(
        byAdding amount: Int,
        _ units: Calendar.Component,
        from initialDate: Date,
        times: Int
    ) {
        self = (0...times).reduce(into: [Date]()) { dates, offset in
            dates.append(initialDate.adding(amount * offset, units))
        }
    }
}
