enum ImplicitlyUnwrappedOptional<Value> {
    case some(Value)
    /// Retrieving the underlying value for this case will cause the program to crash.
    case none
}

extension ImplicitlyUnwrappedOptional {
    func callAsFunction(file: StaticString = #file, line: UInt = #line) -> Value {
        switch self {
        case .some(let value):
            return value
        case .none:
            preconditionFailure("No value found on access to '\(self)' (\(file):\(line))")
        }
    }
}
