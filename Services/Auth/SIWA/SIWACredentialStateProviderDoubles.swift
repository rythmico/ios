final class SIWACredentialStateFetcherStub: SIWACredentialStateProvider {
    var expectedState: State

    init(expectedState: State) {
        self.expectedState = expectedState
    }

    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler) {
        completion(expectedState)
    }
}

final class SIWACredentialStateFetcherDummy: SIWACredentialStateProvider {
    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler) {}
}
