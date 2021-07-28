extension JSONDecoder: Then {}
extension URLRequest: Then {}

extension Then where Self: Any {
    public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        with { $0[keyPath: keyPath] = value }
    }
}

extension Then where Self: AnyObject {
    public func with<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, _ value: T) -> Self {
        then { $0[keyPath: keyPath] = value }
    }
}

extension Then {
    @discardableResult
    public func assign<T>(to subject: inout T, _ keyPath: WritableKeyPath<T, Self>) -> Self {
        subject[keyPath: keyPath] = self
        return self
    }

    @discardableResult
    public func assign<T>(to subject: inout T, _ keyPath: WritableKeyPath<T, Self?>) -> Self {
        subject[keyPath: keyPath] = self
        return self
    }
}

extension Then {
    @discardableResult
    public func assign<T>(to subject: T, _ keyPath: ReferenceWritableKeyPath<T, Self>) -> Self {
        subject[keyPath: keyPath] = self
        return self
    }

    @discardableResult
    public func assign<T>(to subject: T, _ keyPath: ReferenceWritableKeyPath<T, Self?>) -> Self {
        subject[keyPath: keyPath] = self
        return self
    }
}
