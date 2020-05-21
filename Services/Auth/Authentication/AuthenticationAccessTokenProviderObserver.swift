import Foundation
import Combine
import Sugar

protocol AuthenticationAccessTokenProviderObserving: ObservableObject {
    var currentProvider: AuthenticationAccessTokenProvider? { get }
}

final class AuthenticationAccessTokenProviderObserver: AuthenticationAccessTokenProviderObserving {
    private let broadcast: AuthenticationAccessTokenProviderBroadcastProtocol
    private var token: AuthenticationAccessTokenProviderBroadcastProtocol.ListenerToken?

    @Published private(set) var currentProvider: AuthenticationAccessTokenProvider?

    init(broadcast: AuthenticationAccessTokenProviderBroadcastProtocol) {
        self.broadcast = broadcast
        self.currentProvider = broadcast.currentProvider
        subscribeToBroadcast()
    }

    private func subscribeToBroadcast() {
        token = broadcast.addStateDidChangeListener { provider in
            self.currentProvider = provider
        }
    }

    deinit {
        token.map(broadcast.removeStateDidChangeListener)
    }
}
