import FoundationEncore

extension AppleAuthorizationCredential {
    static let stub = AppleAuthorizationCredential(
        userId: "USER_ID",
        fullName: "David Roman",
        email: "d@vidroman.dev",
        identityToken: "IDENTITY_TOKEN",
        nonce: "NONCE"
    )
}
