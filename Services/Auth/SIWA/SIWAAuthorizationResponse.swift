import AuthenticationServices

typealias SIWAAuthorizationResponse = ASAuthorizationAppleIDCredential

protocol SIWAAuthorizationResponseProtocol {
    var userID: String { get }
    var fullName: PersonNameComponents? { get }
    var email: String? { get }
    var identityToken: Data? { get }
}

extension ASAuthorizationAppleIDCredential: SIWAAuthorizationResponseProtocol {
    var userID: String { user }
}
