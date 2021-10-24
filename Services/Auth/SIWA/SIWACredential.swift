/// Sign in with Apple credential
struct SIWACredential: Codable, Equatable {
    struct UserInfo: Codable, Equatable {
        var userID: String
        var name: String?
        var email: String?
    }
    var userInfo: UserInfo
    var identityToken: String
    var nonce: String
}
