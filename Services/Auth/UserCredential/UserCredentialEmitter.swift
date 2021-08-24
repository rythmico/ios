import FoundationEncore
import FirebaseAuth

protocol UserCredentialEmitterProtocol {
    typealias ListenerBlock = Handler<UserCredentialProtocol?>
    typealias ListenerToken = NSObjectProtocol
    var userCredential: UserCredentialProtocol? { get }
    func addStateDidChangeListener(_ listener: @escaping ListenerBlock) -> ListenerToken
    func removeStateDidChangeListener(_ listenerToken: ListenerToken)
}

func UserCredentialEmitter() -> _UserCredentialEmitter { Auth.auth() }

typealias _UserCredentialEmitter = FirebaseAuth.Auth

extension Auth: UserCredentialEmitterProtocol {
    var userCredential: UserCredentialProtocol? {
        currentUser
    }

    func addStateDidChangeListener(_ listener: @escaping ListenerBlock) -> ListenerToken {
        addStateDidChangeListener { (_: Auth, user: User?) in
            listener(user)
        }
    }
}
