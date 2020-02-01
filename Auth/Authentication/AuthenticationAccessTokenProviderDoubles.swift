import Sugar

final class AuthenticationAccessTokenProviderStub: AuthenticationAccessTokenProvider {
    var expectedResult: AccessTokenResult

    init(expectedResult: AccessTokenResult) {
        self.expectedResult = expectedResult
    }

    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {
        completionHandler(expectedResult)
    }
}

final class AuthenticationAccessTokenProviderDummy: AuthenticationAccessTokenProvider {
    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {}
}
