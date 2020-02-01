final class AppleAuthorizationCredentialStateFetcherStub: AppleAuthorizationCredentialStateProvider {
    var expectedState: State

    init(expectedState: State) {
        self.expectedState = expectedState
    }

    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler) {
        completion(expectedState)
    }
}
