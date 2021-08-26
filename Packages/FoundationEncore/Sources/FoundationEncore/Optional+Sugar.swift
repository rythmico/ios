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

extension Optional {
    public func mapToAction(_ transform: @escaping (Wrapped) -> Void) -> Action? {
        self.map { value in
            { transform(value) }
        }
    }
}

infix operator =?? : AssignmentPrecedence

public func =?? <T>(optional: inout T?, value: @autoclosure () -> T) {
    optional = optional ?? value()
}
