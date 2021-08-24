import FoundationEncore

final class AppleAuthorizationServiceStub: AppleAuthorizationServiceProtocol {
    var result: AuthorizationResult

    init(result: AuthorizationResult) {
        self.result = result
    }

    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {
        completionHandler(result)
    }
}

final class AppleAuthorizationServiceDummy: AppleAuthorizationServiceProtocol {
    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {}
}
