import AuthenticationServices

typealias AppleAuthorizationResponse = ASAuthorizationAppleIDCredential

protocol AppleAuthorizationResponseProtocol {
    var userId: String { get }
    var fullName: PersonNameComponents? { get }
    var email: String? { get }
    var identityToken: Data? { get }
}

extension AppleAuthorizationResponse: AppleAuthorizationResponseProtocol {
    var userId: String { user }
}
