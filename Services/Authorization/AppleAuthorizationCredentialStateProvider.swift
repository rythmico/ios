import AuthenticationServices

protocol AppleAuthorizationCredentialStateProvider {
    typealias State = ASAuthorizationAppleIDProvider.CredentialState
    typealias StateHandler = Handler<State>
    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler)
}

typealias AppleAuthorizationCredentialStateFetcher = ASAuthorizationAppleIDProvider

extension AppleAuthorizationCredentialStateFetcher: AppleAuthorizationCredentialStateProvider {
    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler) {
        getCredentialState(forUserID: userID) { state, error in
            completion(state)
        }
    }
}
