import Sugar

public final class AuthenticationAccessTokenProviderStub: AuthenticationAccessTokenProvider {
    public var expectedResult: AccessTokenResult

    public init(expectedResult: AccessTokenResult) {
        self.expectedResult = expectedResult
    }

    public func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {
        completionHandler(expectedResult)
    }
}

public final class AuthenticationAccessTokenProviderDummy: AuthenticationAccessTokenProvider {
    public init() {}

    public func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {}
}
