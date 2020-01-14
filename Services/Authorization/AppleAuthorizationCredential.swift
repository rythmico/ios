import AuthenticationServices

typealias AppleAuthorizationCredential = ASAuthorizationAppleIDCredential

protocol AppleAuthorizationCredentialProtocol {
    var identityToken: Data? { get }
}

extension AppleAuthorizationCredential: AppleAuthorizationCredentialProtocol {}
