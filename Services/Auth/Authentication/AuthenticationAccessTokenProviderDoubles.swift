import Sugar

final class AuthenticationAccessTokenProviderStub: AuthenticationAccessTokenProvider {
    var result: AccessTokenResult

    init(result: AccessTokenResult) {
        self.result = result
    }

    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {
        completionHandler(result)
    }
}

final class AuthenticationAccessTokenProviderDummy: AuthenticationAccessTokenProvider {
    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {}
}
