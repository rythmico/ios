import Sugar

final class AppleAuthorizationServiceStub: AppleAuthorizationServiceProtocol {
    var expectedResult: AuthorizationResult

    init(expectedResult: AuthorizationResult) {
        self.expectedResult = expectedResult
    }

    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {
        completionHandler(expectedResult)
    }
}

final class AppleAuthorizationServiceDummy: AppleAuthorizationServiceProtocol {
    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {}
}
