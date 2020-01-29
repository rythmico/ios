import Sugar

public final class DeauthenticationServiceSpy: DeauthenticationServiceProtocol {
    public var deauthenticationCount = 0

    private let accessTokenProviderObserver: AuthenticationAccessTokenProviderObserving

    public init(accessTokenProviderObserver: AuthenticationAccessTokenProviderObserving) {
        self.accessTokenProviderObserver = accessTokenProviderObserver
    }

    public func deauthenticate() {
        deauthenticationCount += 1
        accessTokenProviderObserver.statusDidChangeHandler?(nil)
    }
}
