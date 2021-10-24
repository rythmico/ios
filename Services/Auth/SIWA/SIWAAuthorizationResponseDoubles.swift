import FoundationEncore

struct SIWAAuthorizationResponseStub: SIWAAuthorizationResponseProtocol {
    var userID: String
    var fullName: PersonNameComponents?
    var email: String?
    var identityToken: Data?

    init(userID: String, fullName: PersonNameComponents?, email: String?, identityToken: String?) {
        self.userID = userID
        self.fullName = fullName
        self.email = email
        self.identityToken = (identityToken?.utf8).map(Data.init(_:))
    }
}

struct SIWAAuthorizationResponseDummy: SIWAAuthorizationResponseProtocol {
    var userID: String = .empty
    var fullName: PersonNameComponents?
    var email: String?
    var identityToken: Data?
}
