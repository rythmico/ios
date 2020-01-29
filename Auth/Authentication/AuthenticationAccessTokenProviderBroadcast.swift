import Foundation
import FirebaseAuth
import Sugar

public protocol AuthenticationAccessTokenProviderBroadcastProtocol {
    typealias ListenerBlock = Handler<AuthenticationAccessTokenProvider?>
    typealias ListenerToken = NSObjectProtocol
    var currentProvider: AuthenticationAccessTokenProvider? { get }
    func addStateDidChangeListener(_ listener: @escaping ListenerBlock) -> ListenerToken
    func removeStateDidChangeListener(_ listenerToken: ListenerToken)
}

public func AuthenticationAccessTokenProviderBroadcast() -> _AuthenticationAccessTokenProviderBroadcast { Auth.auth() }

public typealias _AuthenticationAccessTokenProviderBroadcast = FirebaseAuth.Auth

extension Auth: AuthenticationAccessTokenProviderBroadcastProtocol {
    public var currentProvider: AuthenticationAccessTokenProvider? {
        currentUser
    }

    public func addStateDidChangeListener(_ listener: @escaping ListenerBlock) -> ListenerToken {
        addStateDidChangeListener { (_: Auth, user: User?) in
            listener(user)
        }
    }
}
