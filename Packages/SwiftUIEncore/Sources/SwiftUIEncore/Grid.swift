// TODO: use implicit CGFloat <-> Double conversion in Swift 5.5

public struct Grid {
    fileprivate static let baseUnit: CGFloat = 4

    public enum Value: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
        case max
        case other(CGFloat)

        public init(integerLiteral value: IntegerLiteralType) { self = .other(CGFloat(value)) }
        public init(floatLiteral value: FloatLiteralType) { self = .other(CGFloat(value)) }

        fileprivate var value: CGFloat {
            switch self {
            case .max:
                return 125
            case .other(let n):
                return n
            }
        }
    }
}

extension CGFloat {
    public static func grid(_ n: Grid.Value) -> Self { Grid.baseUnit * n.value }
}
