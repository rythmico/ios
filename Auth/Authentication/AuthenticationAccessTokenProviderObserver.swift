import Foundation
import Sugar

protocol AuthenticationAccessTokenProviderObserving: AnyObject {
    typealias StatusDidChangeHandler = Handler<AuthenticationAccessTokenProvider?>
    var statusDidChangeHandler: StatusDidChangeHandler? { get set }
}

final class AuthenticationAccessTokenProviderObserver: AuthenticationAccessTokenProviderObserving {
    private let broadcast: AuthenticationAccessTokenProviderBroadcastProtocol
    private var token: AuthenticationAccessTokenProviderBroadcastProtocol.ListenerToken?

    var statusDidChangeHandler: StatusDidChangeHandler? {
        didSet {
            handlerDidChange()
        }
    }

    init(broadcast: AuthenticationAccessTokenProviderBroadcastProtocol) {
        self.broadcast = broadcast
    }

    private func handlerDidChange() {
        removeExistingTokenizedHandlerIfNeeded()
        statusDidChangeHandler?(broadcast.currentProvider)
        token = broadcast.addStateDidChangeListener { [weak self] provider in
            self?.statusDidChangeHandler?(provider)
        }
    }

    private func removeExistingTokenizedHandlerIfNeeded() {
        guard let token = token else {
            return
        }
        broadcast.removeStateDidChangeListener(token)
    }

    deinit {
        removeExistingTokenizedHandlerIfNeeded()
    }
}
