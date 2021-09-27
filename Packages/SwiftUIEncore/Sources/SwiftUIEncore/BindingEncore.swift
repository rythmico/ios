extension Binding {
    public typealias Getter = () -> Value
    public typealias Setter = (Value) -> Void

    public var getter: Getter {
        { wrappedValue }
    }

    public var setter: Setter {
        { wrappedValue = $0 }
    }

    public func setter(to value: Value) -> Action {
        { setter(value) }
    }
}

extension Binding where Value == Bool {
    public init<Wrapped>(trueIfSome optional: Binding<Wrapped?>) {
        self.init(
            get: { optional.wrappedValue != nil },
            set: { if !$0 { optional.wrappedValue = nil } }
        )
    }
}

extension Binding {
    public func or<Wrapped>(_ otherValue: Wrapped) -> Binding<Wrapped> where Value == Wrapped? {
        Binding<Wrapped>(
            get: { wrappedValue ?? otherValue },
            set: { wrappedValue = $0 }
        )
    }
}
