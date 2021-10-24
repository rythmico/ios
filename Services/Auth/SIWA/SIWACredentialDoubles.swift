import FoundationEncore

extension SIWACredential {
    static let stub = SIWACredential(
        userInfo: UserInfo(
            userID: "USER_ID",
            name: "David Roman",
            email: "d@vidroman.dev"
        ),
        identityToken: "IDENTITY_TOKEN",
        nonce: "NONCE"
    )
}
