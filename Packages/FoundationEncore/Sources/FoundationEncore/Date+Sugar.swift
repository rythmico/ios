infix operator <- : AdditionPrecedence

extension Date {
    fileprivate static var calendar: Calendar { .neutral }

    public static func <- (lhs: Date, rhs: (amount: Int, units: Set<Calendar.Component>)) -> Date {
        lhs.setting(
            rhs.units.reduce(into: DateComponents()) { $0.setValue(rhs.amount, for: $1) }
        ) !! preconditionFailure(
            "Date mutation failed with 'date' \(lhs) 'amount' \(rhs.amount) 'units' \(rhs.units) 'calendar' \(calendar)"
        )
    }

    public static func <- (lhs: Date, rhs: (amount: Int, unit: Calendar.Component)) -> Date {
        lhs <- (rhs.amount, [rhs.unit])
    }

    public static func + (lhs: Date, rhs: (amount: Int, unit: Calendar.Component)) -> Date {
        calendar.date(byAdding: rhs.unit, value: rhs.amount, to: lhs) !! preconditionFailure(
            "Date addition failed with 'date' \(lhs) 'amount' \(rhs.amount) 'unit' \(rhs.unit) 'calendar' \(calendar)"
        )
    }

    public static func - (lhs: Date, rhs: (amount: Int, unit: Calendar.Component)) -> Date {
        lhs + (-rhs.amount, rhs.unit)
    }

    public static func - (lhs: Date, rhs: (date: Date, unit: Calendar.Component)) -> Int {
        calendar.dateComponents([rhs.unit], from: rhs.date, to: lhs).value(for: rhs.unit) !! preconditionFailure(
            "Date diff failed with 'toDate' \(lhs) 'fromDate' \(rhs.date) 'unit' \(rhs.unit) 'calendar' \(calendar)"
        )
    }
}

extension Date {
    public init(date: Date, time: Date) {
        let calendar = Self.calendar
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        self = date.setting(timeComponents) !! preconditionFailure(
            "Date merging failed with 'date' \(date) 'time' \(time) 'calendar' \(calendar)"
        )
    }

    public func setting(_ components: DateComponents) -> Date? {
        let calendar = Self.calendar
        let allUnits: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let originalComponents = calendar.dateComponents(allUnits, from: self)
        let newComponents = allUnits.reduce(into: originalComponents) { acc, unit in
            acc.setValue(components.optionalValue(for: unit) ?? acc.optionalValue(for: unit), for: unit)
        }
        return calendar.date(from: newComponents)
    }
}

extension Date {
    public static var referenceDate: Date {
        Date(timeIntervalSinceReferenceDate: .zero)
    }
}

extension DateComponents {
    public func optionalValue(for unit: Calendar.Component) -> Int? {
        guard let value = self.value(for: unit), value != NSNotFound else {
            return nil
        }
        return value
    }
}
