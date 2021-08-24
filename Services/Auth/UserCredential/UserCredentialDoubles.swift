import FoundationEncore

final class UserCredentialStub: UserCredentialProtocol {
    let userId: String = "USER_ID"
    let name: String? = "David Roman"
    let email: String? = "david@rythmico.com"
    var result: AccessTokenResult

    init(result: AccessTokenResult) {
        self.result = result
    }

    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {
        completionHandler(result)
    }
}

// TODO: `extension UserCredentialProtocol where Self == UserCredentialStub` in Swift 5.5
extension UserCredentialStub {
    static let success = UserCredentialStub(result: .success("ACCESS_TOKEN"))
}

final class UserCredentialDummy: UserCredentialProtocol {
    let userId: String = "USER_ID"
    let name: String? = nil
    let email: String? = nil
    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {}
}
