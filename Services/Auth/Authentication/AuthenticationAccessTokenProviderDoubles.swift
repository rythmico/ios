import FoundationSugar

final class AuthenticationAccessTokenProviderStub: AuthenticationAccessTokenProvider {
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

final class AuthenticationAccessTokenProviderDummy: AuthenticationAccessTokenProvider {
    let userId: String = "USER_ID"
    let name: String? = nil
    let email: String? = nil
    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {}
}
