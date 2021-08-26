infix operator =?? : AssignmentPrecedence

extension Optional {
    /// Assigns a default value to variable, if such variable is nil.
    ///
    /// ```
    /// var foo: Int? = nil
    /// foo =?? 5 // Equivalent to `foo = foo ?? 5`
    /// print(foo) // Optional(5)
    /// ```
    public static func =?? (optional: inout Self, defaultValue: @autoclosure () -> Wrapped) {
        optional = optional ?? defaultValue()
    }
}

extension Optional {
    public func mapToAction(_ transform: @escaping (Wrapped) -> Void) -> Action? {
        self.map { value in
            { transform(value) }
        }
    }
}

extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        self?.isEmpty != false
    }
}

extension Optional where Wrapped: NSNumber {
    public var isNilOrZero: Bool {
        self.map { $0.intValue == 0 } ?? true
    }
}
