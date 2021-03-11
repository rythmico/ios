import FoundationSugar

final class AuthenticationAccessTokenProviderStub: AuthenticationAccessTokenProvider {
    let userId: String = "USER_ID"
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
    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {}
}
