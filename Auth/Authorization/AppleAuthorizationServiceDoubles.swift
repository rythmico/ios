import Sugar

public final class AppleAuthorizationServiceStub: AppleAuthorizationServiceProtocol {
    public var expectedResult: AuthorizationResult

    public init(expectedResult: AuthorizationResult) {
        self.expectedResult = expectedResult
    }

    public func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {
        completionHandler(expectedResult)
    }
}
