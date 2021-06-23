import FoundationSugar

struct AppleAuthorizationResponseStub: AppleAuthorizationResponseProtocol {
    var userId: String
    var fullName: PersonNameComponents?
    var email: String?
    var identityToken: Data?

    init(userId: String, fullName: PersonNameComponents?, email: String?, identityToken: String?) {
        self.userId = userId
        self.fullName = fullName
        self.email = email
        self.identityToken = (identityToken?.utf8).map(Data.init(_:))
    }
}

struct AppleAuthorizationResponseDummy: AppleAuthorizationResponseProtocol {
    var userId = String()
    var fullName: PersonNameComponents?
    var email: String?
    var identityToken: Data?
}
