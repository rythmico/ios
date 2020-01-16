import AuthenticationServices

typealias AppleAuthorizationResponse = ASAuthorizationAppleIDCredential

protocol AppleAuthorizationResponseProtocol {
    var identityToken: Data? { get }
}

extension AppleAuthorizationResponse: AppleAuthorizationResponseProtocol {}
