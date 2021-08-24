import FoundationEncore

extension Date: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = ISO8601DateFormatter().date(from: value) !! preconditionFailure(
            "Could not parse string literal '\(value)' into ISO 8601 date"
        )
    }
}

extension Date {
    static var stub: Date {
        "2020-07-13T12:15:00Z"
    }
}
