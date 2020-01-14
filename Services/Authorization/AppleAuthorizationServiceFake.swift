final class AppleAuthorizationServiceFake: AppleAuthorizationServiceProtocol {
    var expectedResult: AuthorizationResult

    init(expectedResult: AuthorizationResult) {
        self.expectedResult = expectedResult
    }

    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {
        completionHandler(expectedResult)
    }
}
