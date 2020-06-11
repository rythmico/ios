import Foundation
import Combine
import Sugar

class AuthenticationAccessTokenProviderObserverBase: ObservableObject {
    @Published var currentProvider: AuthenticationAccessTokenProvider?
}

final class AuthenticationAccessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase {
    private let broadcast: AuthenticationAccessTokenProviderBroadcastProtocol
    private var token: AuthenticationAccessTokenProviderBroadcastProtocol.ListenerToken?

    init(broadcast: AuthenticationAccessTokenProviderBroadcastProtocol) {
        self.broadcast = broadcast
        super.init()
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
