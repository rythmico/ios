infix operator <- : AdditionPrecedence

extension Date {
    fileprivate static var calendar: Calendar { .neutral }

    public static func <- (lhs: Date, rhs: (amount: Int, units: [Calendar.Component])) -> Date {
        rhs.units.reduce(lhs) { acc, unit in
            calendar.date(bySetting: unit, value: rhs.amount, of: acc) !! preconditionFailure(
                "Date mutation failed with 'date' \(acc) 'amount' \(rhs.amount) 'unit' \(unit) 'calendar' \(calendar)"
            )
        }
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
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)

        let dateTimeComponents = DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: timeComponents.hour,
            minute: timeComponents.minute,
            second: timeComponents.second
        )

        self = calendar.date(from: dateTimeComponents) !! preconditionFailure(
            "Date merging failed with 'date' \(date) 'time' \(time) 'calendar' \(calendar)"
        )
    }
}

extension Date {
    public static var referenceDate: Date {
        Date(timeIntervalSinceReferenceDate: .zero)
    }
}
