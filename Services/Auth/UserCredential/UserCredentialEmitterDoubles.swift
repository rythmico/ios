import Foundation
import FoundationSugar

final class UserCredentialEmitterSpy: UserCredentialEmitterProtocol {
    var userCredential: UserCredentialProtocol?
    var returnedToken: Int

    init(userCredential: UserCredentialProtocol?, returnedToken: Int) {
        self.returnedToken = returnedToken
    }

    var didAddStateDidChangeListener: Handler<ListenerBlock>?
    func addStateDidChangeListener(_ listener: @escaping ListenerBlock) -> ListenerToken {
        didAddStateDidChangeListener?(listener)
        return NSNumber(integerLiteral: returnedToken)
    }

    var didRemoveStateDidChangeListener: Handler<ListenerToken>?
    func removeStateDidChangeListener(_ listenerToken: ListenerToken) {
        didRemoveStateDidChangeListener?(listenerToken)
    }
}
