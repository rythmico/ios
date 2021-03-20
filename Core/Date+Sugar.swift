import Foundation
import FoundationSugar

extension Date {
    public static func |> (lhs: Date, rhs: (amount: Int, units: Calendar.Component)) -> Date {
        lhs |> (rhs.amount, rhs.units, Current.calendar())
    }

    public static func + (lhs: Date, rhs: (amount: Int, units: Calendar.Component)) -> Date {
        lhs + (rhs.amount, rhs.units, Current.calendar())
    }

    public static func - (lhs: Date, rhs: (amount: Int, units: Calendar.Component)) -> Date {
        lhs - (rhs.amount, rhs.units, Current.calendar())
    }

    public static func - (lhs: Date, rhs: (date: Date, units: Calendar.Component)) -> Int {
        lhs - (rhs.date, rhs.units, Current.calendar())
    }
}
