import Foundation
import FirebaseAuth
import FoundationSugar

protocol AuthenticationAccessTokenProviderBroadcastProtocol {
    typealias ListenerBlock = Handler<AuthenticationAccessTokenProvider?>
    typealias ListenerToken = NSObjectProtocol
    var currentProvider: AuthenticationAccessTokenProvider? { get }
    func addStateDidChangeListener(_ listener: @escaping ListenerBlock) -> ListenerToken
    func removeStateDidChangeListener(_ listenerToken: ListenerToken)
}

func AuthenticationAccessTokenProviderBroadcast() -> _AuthenticationAccessTokenProviderBroadcast { Auth.auth() }

typealias _AuthenticationAccessTokenProviderBroadcast = FirebaseAuth.Auth

extension Auth: AuthenticationAccessTokenProviderBroadcastProtocol {
    var currentProvider: AuthenticationAccessTokenProvider? {
        currentUser
    }

    func addStateDidChangeListener(_ listener: @escaping ListenerBlock) -> ListenerToken {
        addStateDidChangeListener { (_: Auth, user: User?) in
            listener(user)
        }
    }
}
