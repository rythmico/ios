public struct AnyEquatable: Equatable {
    let value: Any
    let valueIsEqualTo: (Any) -> Bool

    public init<Value>(_ value: Value) where Value: Equatable {
        self.value = value
        self.valueIsEqualTo = { $0 as? Value == value }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.valueIsEqualTo(rhs.value)
    }
}
