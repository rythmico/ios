import Foundation
import FoundationSugar

final class AuthenticationAccessTokenProviderBroadcastSpy: AuthenticationAccessTokenProviderBroadcastProtocol {
    var currentProvider: AuthenticationAccessTokenProvider?
    var returnedToken: Int

    init(currentProvider: AuthenticationAccessTokenProvider?, returnedToken: Int) {
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
