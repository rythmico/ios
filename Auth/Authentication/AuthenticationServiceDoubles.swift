import Sugar

final class AuthenticationServiceStub: AuthenticationServiceProtocol {
    var expectedResult: AuthenticationResult

    init(expectedResult: AuthenticationResult) {
        self.expectedResult = expectedResult
    }

    func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>) {
        completionHandler(expectedResult)
    }
}

final class AuthenticationServiceDummy: AuthenticationServiceProtocol {
    func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>) {}
}
