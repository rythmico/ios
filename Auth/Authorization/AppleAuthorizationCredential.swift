public struct AppleAuthorizationCredential: Equatable {
    public var userId: String
    public var fullName: String?
    public var email: String?
    public var identityToken: String
    public var nonce: String

    public init(userId: String, fullName: String?, email: String?, identityToken: String, nonce: String) {
        self.userId = userId
        self.fullName = fullName
        self.email = email
        self.identityToken = identityToken
        self.nonce = nonce
    }
}
