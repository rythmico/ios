import Foundation

extension Array {
    public subscript(safe index: Index) -> Element? {
        dropFirst(index).first
    }
}

@resultBuilder
public struct ArrayBuilder<Element> {
    public static func buildArray(_ arrays: [Array<Element>]) -> Array<Element> { arrays.reduce([], +) }
    public static func buildBlock(_ arrays: Array<Element>...) -> Array<Element> { arrays.reduce([], +) }
    public static func buildEither(first array: Array<Element>) -> Array<Element> { array }
    public static func buildEither(second array: Array<Element>) -> Array<Element> { array }
    public static func buildExpression(_ element: Element) -> Array<Element> { [element] }
    public static func buildLimitedAvailability(_ array: Array<Element>) -> Array<Element> { array }
    public static func buildOptional(_ array: Array<Element>?) -> Array<Element> { array ?? [] }
}

extension Array {
    public static func build(@ArrayBuilder<Element> _ build: () -> Self) -> Self {
        build()
    }
}
