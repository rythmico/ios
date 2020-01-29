import Sugar

public final class AuthenticationServiceStub: AuthenticationServiceProtocol {
    public var expectedResult: AuthenticationResult

    public init(expectedResult: AuthenticationResult) {
        self.expectedResult = expectedResult
    }

    public func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>) {
        completionHandler(expectedResult)
    }
}
