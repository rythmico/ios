public final class AuthenticationAccessTokenProviderObserverStub: AuthenticationAccessTokenProviderObserving {
    public let expectedProvider: AuthenticationAccessTokenProvider?

    public var statusDidChangeHandler: StatusDidChangeHandler? {
        didSet {
            statusDidChangeHandler?(expectedProvider)
        }
    }

    public init(expectedProvider: AuthenticationAccessTokenProvider?) {
        self.expectedProvider = expectedProvider
    }
}
