import Foundation
import Combine

final class AnalyticsCoordinator {
    private let service: AnalyticsServiceProtocol
    private let userCredentialProvider: UserCredentialProviderBase
    private var cancellable: AnyCancellable?

    init(
        service: AnalyticsServiceProtocol,
        userCredentialProvider: UserCredentialProviderBase
    ) {
        self.service = service
        self.userCredentialProvider = userCredentialProvider
        self.cancellable = userCredentialProvider.$userCredential.sink(receiveValue: onUserCredentialChanged)
    }

    private func onUserCredentialChanged(_ credential: UserCredentialProtocol?) {
        if let credential = credential {
            service.identify(distinctId: credential.userId)
            service.set(name: credential.name, email: credential.email)
        } else {
            service.reset()
        }
    }
}
