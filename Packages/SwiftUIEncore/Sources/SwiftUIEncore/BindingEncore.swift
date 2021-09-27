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

extension Binding {
    public func isPresent<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        Binding<Bool>(
            get: {
                wrappedValue != nil
            },
            set: { isPresent in
                if !isPresent {
                    wrappedValue = nil
                }
            }
        )
    }

    public func or<Wrapped>(_ otherValue: Wrapped) -> Binding<Wrapped> where Value == Wrapped? {
        Binding<Wrapped>(
            get: { wrappedValue ?? otherValue },
            set: { wrappedValue = $0 }
        )
    }
}
