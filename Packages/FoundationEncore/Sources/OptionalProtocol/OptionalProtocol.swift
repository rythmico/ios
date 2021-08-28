public protocol OptionalProtocol: ExpressibleByNilLiteral {
    associatedtype Wrapped

    static func some(_ wrapped: Wrapped) -> Self
    static var none: Self { get }

    var value: Wrapped? { get set }
}

extension Optional: OptionalProtocol {
    public var value: Wrapped? {
        get { self }
        set { self = newValue }
    }
}
