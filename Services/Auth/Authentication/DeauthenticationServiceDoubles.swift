import Sugar

final class DeauthenticationServiceStub: DeauthenticationServiceProtocol {
    private let accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase

    init(accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase) {
        self.accessTokenProviderObserver = accessTokenProviderObserver
    }

    func deauthenticate() {
        accessTokenProviderObserver.currentProvider = nil
    }
}

final class DeauthenticationServiceSpy: DeauthenticationServiceProtocol {
    var deauthenticationCount = 0
    private let accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase

    init(accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase) {
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
