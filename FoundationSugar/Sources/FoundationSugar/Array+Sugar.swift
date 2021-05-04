import Foundation

@resultBuilder
public struct ArrayBuilder<Element> {
    public typealias Array = Swift.Array<Element>

    public static func buildArray(_ arrays: [Array]) -> Array { arrays.reduce([], +) }
    public static func buildBlock(_ arrays: Array...) -> Array { arrays.reduce([], +) }
    public static func buildEither(first array: Array) -> Array { array }
    public static func buildEither(second array: Array) -> Array { array }
    public static func buildExpression(_ element: Element) -> Array { [element] }
    public static func buildExpression(_ array: Array) -> Array { array }
    public static func buildLimitedAvailability(_ array: Array) -> Array { array }
    public static func buildOptional(_ array: Array?) -> Array { array ?? [] }
}

extension Array {
    public init(@ArrayBuilder<Element> build: () -> Self) {
        self = build()
    }
}
