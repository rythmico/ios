public final class AppleAuthorizationCredentialStateFetcherStub: AppleAuthorizationCredentialStateProvider {
    public var expectedState: State

    public init(expectedState: State) {
        self.expectedState = expectedState
    }

    public func getCredentialState(forUserID userID: String, completion: @escaping StateHandler) {
        completion(expectedState)
    }
}
