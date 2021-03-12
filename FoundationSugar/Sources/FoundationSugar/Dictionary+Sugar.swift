import Foundation

extension Dictionary where Key == String, Value == String {
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.merging(rhs, uniquingKeysWith: { lhs, rhs in rhs })
    }
}

@resultBuilder
public struct DictionaryBuilder<Key: Hashable, Value> {
    public static func buildBlock(_ dictionaries: Dictionary<Key, Value>...) -> Dictionary<Key, Value> {
        dictionaries.reduce(into: [:]) {
            $0.merge($1) { _, new in new }
        }
    }

    public static func buildOptional(_ dictionary: Dictionary<Key, Value>?) -> Dictionary<Key, Value> {
        dictionary ?? [:]
    }
}

extension Dictionary {
    public init(@DictionaryBuilder<Key, Value> build: () -> Dictionary) {
        self = build()
    }
}
