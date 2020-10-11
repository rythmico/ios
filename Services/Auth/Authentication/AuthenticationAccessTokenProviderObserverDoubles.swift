import Combine

final class AuthenticationAccessTokenProviderObserverStub: AuthenticationAccessTokenProviderObserverBase {
    init(currentProvider: AuthenticationAccessTokenProvider?) {
        super.init()
        self.currentProvider = currentProvider
    }
}

final class AuthenticationAccessTokenProviderObserverDummy: AuthenticationAccessTokenProviderObserverBase {}
