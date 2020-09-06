#if DEBUG
final class AppleAuthorizationCredentialStateFetcherStub: AppleAuthorizationCredentialStateProvider {
    var expectedState: State

    init(expectedState: State) {
        self.expectedState = expectedState
    }

    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler) {
        completion(expectedState)
    }
}

final class AppleAuthorizationCredentialStateFetcherDummy: AppleAuthorizationCredentialStateProvider {
    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler) {}
}
#endif
