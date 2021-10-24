import FoundationEncore
import AuthenticationServices

protocol SIWACredentialStateProvider {
    typealias State = ASAuthorizationAppleIDProvider.CredentialState
    typealias StateHandler = Handler<State>
    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler)
}

typealias SIWACredentialStateFetcher = ASAuthorizationAppleIDProvider

extension SIWACredentialStateFetcher: SIWACredentialStateProvider {
    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler) {
        getCredentialState(forUserID: userID) { state, error in
            completion(state)
        }
    }
}
