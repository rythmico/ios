final class AuthenticationAccessTokenProviderObserverStub: AuthenticationAccessTokenProviderObserving {
    let expectedProvider: AuthenticationAccessTokenProvider?

    var statusDidChangeHandler: StatusDidChangeHandler? {
        didSet {
            statusDidChangeHandler?(expectedProvider)
        }
    }

    init(expectedProvider: AuthenticationAccessTokenProvider?) {
        self.expectedProvider = expectedProvider
    }
}
