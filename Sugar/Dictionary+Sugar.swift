import Foundation

extension Dictionary where Key == String, Value == String {
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.merging(rhs, uniquingKeysWith: { lhs, rhs in rhs })
    }
}
