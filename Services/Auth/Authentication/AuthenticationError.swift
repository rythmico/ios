import FoundationSugar

typealias AuthenticationCommonError = AuthenticationError<AuthenticationErrorCommonReasonCode>
typealias AuthenticationSignInError = AuthenticationError<AuthenticationErrorSignInReasonCode>

struct AuthenticationError<ReasonCode: AuthenticationErrorCommonReasonCodeProtocol>: Error {
    var reasonCode: ReasonCode
    var localizedDescription: String
}

extension AuthenticationError {
    init(nsError: NSError) {
        let reasonCode = ReasonCode(rawValue: nsError.code) ?? .unknown
        let localizedDescription = nsError.localizedDescription
        self.init(reasonCode: reasonCode, localizedDescription: localizedDescription)
    }
}

protocol AuthenticationErrorCommonReasonCodeProtocol: RawRepresentable where RawValue == Int {
    // Common
    static var unknown: Self { get }
    static var networkError: Self { get }
    static var tooManyRequests: Self { get }
    // Fatal!
    static var invalidAPIKey: Self { get }
    static var appNotAuthorized: Self { get }
    static var internalError: Self { get }
    static var operationNotAllowed: Self { get }
}

protocol AuthenticationErrorSignInReasonCodeProtocol: AuthenticationErrorCommonReasonCodeProtocol {
    // Sign in with Apple
    static var invalidCredential: Self { get }
    static var userDisabled: Self { get }
    static var invalidEmail: Self { get }
    static var missingOrInvalidNonce: Self { get }
}

enum AuthenticationErrorCommonReasonCode: Int, AuthenticationErrorCommonReasonCodeProtocol {
    // Common
    case unknown = -1, networkError = 17020, tooManyRequests = 17010
    // Fatal!
    case invalidAPIKey = 17023, appNotAuthorized = 17028, internalError = 17999, operationNotAllowed = 17006
}

enum AuthenticationErrorSignInReasonCode: Int, AuthenticationErrorSignInReasonCodeProtocol {
    // Common
    case unknown = -1, networkError = 17020, tooManyRequests = 17010
    // Fatal!
    case invalidAPIKey = 17023, appNotAuthorized = 17028, internalError = 17999, operationNotAllowed = 17006
    // Sign in with Apple
    case invalidCredential = 17004, userDisabled = 17005, invalidEmail = 17008, missingOrInvalidNonce = 17094
}
