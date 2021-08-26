precedencegroup NilAssertingPrecedence {
    associativity: left
    higherThan: NilCoalescingPrecedence
}

infix operator !! : NilAssertingPrecedence

public func !! <T>(optional: T?, exitClosure: @autoclosure () -> Never) -> T {
    guard let value = optional else {
        exitClosure()
    }
    return value
}

public func !! <T>(optional: T?, errorClosure: @autoclosure () -> Error) throws -> T {
    guard let value = optional else {
        throw errorClosure()
    }
    return value
}

infix operator ?! : NilAssertingPrecedence

public func ?! <T>(optional: T?, actionClosure: @autoclosure () -> Void) -> T? {
    guard let value = optional else {
        actionClosure()
        return optional
    }
    return value
}
