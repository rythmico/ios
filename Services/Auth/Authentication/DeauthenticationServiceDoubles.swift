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

    func deauthenticate() {
        deauthenticationCount += 1
    }
}

final class DeauthenticationServiceDummy: DeauthenticationServiceProtocol {
    func deauthenticate() {}
}
