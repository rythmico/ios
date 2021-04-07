import Foundation
import Combine

final class AnalyticsCoordinator {
    private let service: AnalyticsServiceProtocol
    private let userCredentialProvider: UserCredentialProviderBase
    private let accessibilitySettings: AccessibilitySettings

    private var cancellable: AnyCancellable?

    init(
        service: AnalyticsServiceProtocol,
        userCredentialProvider: UserCredentialProviderBase,
        accessibilitySettings: AccessibilitySettings
    ) {
        self.service = service
        self.userCredentialProvider = userCredentialProvider
        self.accessibilitySettings = accessibilitySettings

        self.cancellable = userCredentialProvider.$userCredential.sink(receiveValue: onUserCredentialChanged)
    }

    private func onUserCredentialChanged(_ credential: UserCredentialProtocol?) {
        if let credential = credential {
            service.identify(analyticsUserProfile(with: credential))
        } else {
            service.reset()
        }
    }

    private func analyticsUserProfile(with credential: UserCredentialProtocol) -> AnalyticsUserProfile {
        AnalyticsUserProfile(
            id: credential.userId,
            name: credential.name,
            email: credential.email,
            accessibilitySettings: accessibilitySettings
        )
    }
}
