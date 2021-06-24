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

extension Binding where Value: OptionalProtocol {
    public typealias Wrapped = Value.Wrapped

    public func or(_ value: Wrapped) -> Binding<Wrapped> {
        Binding<Wrapped>(
            get: { wrappedValue.value ?? value },
            set: { wrappedValue = .some($0) }
        )
    }
}
