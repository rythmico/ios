import Foundation

infix operator <- : AdditionPrecedence

extension Date {
    public static func <- (lhs: Date, rhs: (amount: Int, units: [Calendar.Component], calendar: Calendar)) -> Date {
        rhs.units.reduce(lhs) { lhs, unit in
            rhs.calendar.date(bySetting: unit, value: rhs.amount, of: lhs) !! preconditionFailure(
                "Date mutation failed with 'date' \(lhs) 'amount' \(rhs.amount) 'unit' \(unit) 'calendar' \(rhs.calendar)"
            )
        }
    }

    public static func <- (lhs: Date, rhs: (amount: Int, unit: Calendar.Component, calendar: Calendar)) -> Date {
        lhs <- (rhs.amount, [rhs.unit], rhs.calendar)
    }

    public static func + (lhs: Date, rhs: (amount: Int, unit: Calendar.Component, calendar: Calendar)) -> Date {
        rhs.calendar.date(byAdding: rhs.unit, value: rhs.amount, to: lhs) !! preconditionFailure(
            "Date addition failed with 'date' \(lhs) 'amount' \(rhs.amount) 'unit' \(rhs.unit) 'calendar' \(rhs.calendar)"
        )
    }

    public static func - (lhs: Date, rhs: (amount: Int, unit: Calendar.Component, calendar: Calendar)) -> Date {
        lhs + (-rhs.amount, rhs.unit, rhs.calendar)
    }

    public static func - (lhs: Date, rhs: (date: Date, unit: Calendar.Component, calendar: Calendar)) -> Int {
        rhs.calendar.dateComponents([rhs.unit], from: rhs.date, to: lhs).value(for: rhs.unit) !! preconditionFailure(
            "Date diff failed with 'toDate' \(lhs) 'fromDate' \(rhs.date) 'unit' \(rhs.unit) 'calendar' \(rhs.calendar)"
        )
    }
}

extension Date {
    static var referenceDate: Date {
        Date(timeIntervalSinceReferenceDate: .zero)
    }
}
