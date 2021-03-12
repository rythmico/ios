import Foundation
import Combine

final class AnalyticsCoordinator {
    private let service: AnalyticsServiceProtocol
    private let accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase
    private var cancellable: AnyCancellable?

    init(
        service: AnalyticsServiceProtocol,
        accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase
    ) {
        self.service = service
        self.accessTokenProviderObserver = accessTokenProviderObserver
        self.cancellable = accessTokenProviderObserver.$currentProvider.sink(receiveValue: onAccessTokenProviderChanged)
    }

    private func onAccessTokenProviderChanged(_ provider: AuthenticationAccessTokenProvider?) {
        if let provider = provider {
            service.identify(distinctId: provider.userId)
            service.set(name: provider.name, email: provider.email)
        } else {
            service.reset()
        }
    }
}
