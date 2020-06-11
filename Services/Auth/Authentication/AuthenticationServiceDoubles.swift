import Sugar

final class AuthenticationServiceStub: AuthenticationServiceProtocol {
    var result: AuthenticationResult
    var delay: TimeInterval?
    private let accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase

    init(
        result: AuthenticationResult,
        delay: TimeInterval? = nil,
        accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase
    ) {
        self.result = result
        self.delay = delay
        self.accessTokenProviderObserver = accessTokenProviderObserver
    }

    func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>) {
        let work = {
            completionHandler(self.result)

            // Imitate Firebase's singleton behavior.
            switch self.result {
            case .success(let provider):
                self.accessTokenProviderObserver.currentProvider = provider
            case .failure:
                break
            }
        }

        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
        } else {
            work()
        }
    }
}

final class AuthenticationServiceDummy: AuthenticationServiceProtocol {
    func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>) {}
}
