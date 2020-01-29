import Foundation
import Sugar

public protocol AuthenticationAccessTokenProviderObserving: AnyObject {
    typealias StatusDidChangeHandler = Handler<AuthenticationAccessTokenProvider?>
    var statusDidChangeHandler: StatusDidChangeHandler? { get set }
}

public final class AuthenticationAccessTokenProviderObserver: AuthenticationAccessTokenProviderObserving {
    private let broadcast: AuthenticationAccessTokenProviderBroadcastProtocol
    private var token: AuthenticationAccessTokenProviderBroadcastProtocol.ListenerToken?

    public var statusDidChangeHandler: StatusDidChangeHandler? {
        didSet {
            handlerDidChange()
        }
    }

    public init(broadcast: AuthenticationAccessTokenProviderBroadcastProtocol) {
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
