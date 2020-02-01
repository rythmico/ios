import Sugar

final class DeauthenticationServiceSpy: DeauthenticationServiceProtocol {
    var deauthenticationCount = 0

    private let accessTokenProviderObserver: AuthenticationAccessTokenProviderObserving

    init(accessTokenProviderObserver: AuthenticationAccessTokenProviderObserving) {
        self.accessTokenProviderObserver = accessTokenProviderObserver
    }

    func deauthenticate() {
        deauthenticationCount += 1
        accessTokenProviderObserver.statusDidChangeHandler?(nil)
    }
}
