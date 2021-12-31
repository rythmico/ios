import FoundationEncore

final class SIWAAuthorizationServiceStub: SIWAAuthorizationServiceProtocol {
    var result: AuthorizationResult

    init(result: AuthorizationResult) {
        self.result = result
    }

    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {
        completionHandler(result)
    }
}

final class SIWAAuthorizationServiceDummy: SIWAAuthorizationServiceProtocol {
    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {}
}
