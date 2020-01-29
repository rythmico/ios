import AuthenticationServices
import Sugar

public protocol AppleAuthorizationCredentialStateProvider {
    typealias State = ASAuthorizationAppleIDProvider.CredentialState
    typealias StateHandler = Handler<State>
    func getCredentialState(forUserID userID: String, completion: @escaping StateHandler)
}

public typealias AppleAuthorizationCredentialStateFetcher = ASAuthorizationAppleIDProvider

extension AppleAuthorizationCredentialStateFetcher: AppleAuthorizationCredentialStateProvider {
    public func getCredentialState(forUserID userID: String, completion: @escaping StateHandler) {
        getCredentialState(forUserID: userID) { state, error in
            completion(state)
        }
    }
}
