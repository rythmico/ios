import Foundation

// TODO: if/when https://bugs.swift.org/browse/SR-3170 is implemented, look into abstracting AuthenticationError.ReasonCode
// into AuthenticationErrorCommonReasonCodeProtocol and AuthenticationErrorSignInReasonCodeProtocol to merge error types.

protocol AuthenticationErrorProtocol: Error {
    associatedtype ReasonCode: RawRepresentable where ReasonCode.RawValue == Int
    static var defaultReasonCode: ReasonCode { get }
    var reasonCode: ReasonCode { get }
    var localizedDescription: String { get }
    init(reasonCode: ReasonCode, localizedDescription: String)
    init(nsError: NSError)
}

extension AuthenticationErrorProtocol {
    init(nsError: NSError) {
        let reasonCode = ReasonCode(rawValue: nsError.code) ?? Self.defaultReasonCode
        let localizedDescription = nsError.localizedDescription
        self.init(reasonCode: reasonCode, localizedDescription: localizedDescription)
    }
}

struct AuthenticationCommonError: AuthenticationErrorProtocol {
    enum ReasonCode: Int {
        // Common
        case unknown = -1, networkError = 17020, tooManyRequests = 17010
        // Fatal!
        case invalidAPIKey = 17023, appNotAuthorized = 17028, internalError = 17999, operationNotAllowed = 17006
    }

    static var defaultReasonCode: ReasonCode { .unknown }

    var reasonCode: ReasonCode
    var localizedDescription: String
}

struct AuthenticationAPIError: AuthenticationErrorProtocol {
    enum ReasonCode: Int {
        // Common
        case unknown = -1, networkError = 17020, tooManyRequests = 17010
        // Fatal!
        case invalidAPIKey = 17023, appNotAuthorized = 17028, internalError = 17999, operationNotAllowed = 17006
        // Sign in with Apple
        case invalidCredential = 17004, userDisabled = 17005, invalidEmail = 17008, missingOrInvalidNonce = 17094
    }

    static var defaultReasonCode: ReasonCode { .unknown }

    var reasonCode: ReasonCode
    var localizedDescription: String
}
