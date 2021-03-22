import Foundation

public protocol OptionalProtocol {
    associatedtype Wrapped

    var value: Wrapped? { get }

    static func some(_ wrapped: Wrapped) -> Self
    static var none: Self { get }
}

extension Optional: OptionalProtocol {
    public var value: Wrapped? {
        return self
    }
}

extension Optional {
    public mutating func nilifyIfSome() -> Bool {
        switch self {
        case .some:
            self = nil
            return true
        case .none:
            return false
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

infix operator ?! : NilAssertingPrecedence

public func ?! <T>(optional: T?, actionClosure: @autoclosure () -> Void) -> T? {
    guard let value = optional else {
        actionClosure()
        return optional
    }
    return value
}

infix operator ??= : AssignmentPrecedence

public func ??= <T>(optional: inout T?, value: @autoclosure () -> T) {
    optional = optional ?? value()
}
