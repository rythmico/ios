import FoundationEncore

extension AuthenticationError where ReasonCode == AuthenticationErrorSignInReasonCode {
    static let stub = Self(
        underlyingError: NSError(code: .invalidCredential, localizedDescription: "Invalid credential")
    )
}

private extension NSError {
    convenience init(
        code: AuthenticationErrorSignInReasonCode,
        localizedDescription: String
    ) {
        self.init(code: code.rawValue, localizedDescription: localizedDescription)
    }
}
