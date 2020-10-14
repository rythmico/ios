import Foundation

extension Decimal {
    public var isInteger: Bool {
        ulp.distance(to: 1).isZero
    }
}
