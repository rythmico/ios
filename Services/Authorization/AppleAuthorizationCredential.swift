struct AppleAuthorizationCredential: Equatable {
    var userId: String
    var fullName: String?
    var email: String?
    var identityToken: String
    var nonce: String
}
