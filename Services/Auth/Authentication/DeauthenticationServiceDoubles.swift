import Sugar

final class DeauthenticationServiceSpy: DeauthenticationServiceProtocol {
    var deauthenticationCount = 0

    private let accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverStub

    init(accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverStub) {
        self.accessTokenProviderObserver = accessTokenProviderObserver
    }

    func deauthenticate() {
        deauthenticationCount += 1
        accessTokenProviderObserver.currentProvider = nil
    }
}

final class DeauthenticationServiceDummy: DeauthenticationServiceProtocol {
    func deauthenticate() {}
}
