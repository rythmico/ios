import Combine

final class AuthenticationAccessTokenProviderObserverStub: AuthenticationAccessTokenProviderObserving {
    @Published var currentProvider: AuthenticationAccessTokenProvider?

    init(currentProvider: AuthenticationAccessTokenProvider?) {
        self.currentProvider = currentProvider
    }
}
