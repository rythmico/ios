import Foundation

extension Dictionary {
    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.merging(rhs, uniquingKeysWith: { old, new in new })
    }
}

@resultBuilder
public struct DictionaryBuilder<Key: Hashable, Value> {
    public static func buildBlock(_ dictionaries: Dictionary<Key, Value>...) -> Dictionary<Key, Value> { dictionaries.reduce([:], +) }
    public static func buildArray(_ dictionaries: [Dictionary<Key, Value>]) -> Dictionary<Key, Value> { dictionaries.reduce([:], +) }
    public static func buildOptional(_ dictionary: Dictionary<Key, Value>?) -> Dictionary<Key, Value> { dictionary ?? [:] }
    public static func buildEither(first dictionary: Dictionary<Key, Value>) -> Dictionary<Key, Value> { dictionary }
    public static func buildEither(second dictionary: Dictionary<Key, Value>) -> Dictionary<Key, Value> { dictionary }
}

extension Dictionary {
    public init(@DictionaryBuilder<Key, Value> build: () -> Dictionary) {
        self = build()
    }
}
