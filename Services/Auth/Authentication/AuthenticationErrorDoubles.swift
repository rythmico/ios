import FoundationSugar

extension AuthenticationError where ReasonCode == AuthenticationErrorSignInReasonCode {
    static let stub = Self(
        underlyingError: NSError(code: .invalidCredential, localizedDescription: "Invalid credential")
    )
}

// Use <ReasonCode: AuthenticationErrorSignInReasonCodeProtocol> with a protocol extension in Swift 5.5.
private extension NSError {
    convenience init(
        code: AuthenticationErrorSignInReasonCode,
        localizedDescription: String
    ) {
        self.init(code: code.rawValue, localizedDescription: localizedDescription)
    }
}
