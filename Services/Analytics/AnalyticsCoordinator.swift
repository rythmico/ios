import Foundation
import Combine

final class AnalyticsCoordinator {
    private let service: AnalyticsServiceProtocol
    private let userCredentialProvider: UserCredentialProviderBase
    private let accessibilitySettings: AccessibilitySettings
    private let notificationAuthCoordinator: PushNotificationAuthorizationCoordinator

    private var cancellable: AnyCancellable?

    init(
        service: AnalyticsServiceProtocol,
        userCredentialProvider: UserCredentialProviderBase,
        accessibilitySettings: AccessibilitySettings,
        notificationAuthCoordinator: PushNotificationAuthorizationCoordinator
    ) {
        self.service = service
        self.userCredentialProvider = userCredentialProvider
        self.accessibilitySettings = accessibilitySettings
        self.notificationAuthCoordinator = notificationAuthCoordinator

        self.cancellable = Publishers.CombineLatest(
            userCredentialProvider.$userCredential,
            notificationAuthCoordinator.$status
        )
        .map { (credential: $0, notificationAuthStatus: $1) }
        .removeDuplicates {
            $0.credential === $1.credential &&
            $0.notificationAuthStatus == $1.notificationAuthStatus
        }
        .sink { self.identifyOrResetUserProfile(credential: $0, notificationAuthStatus: $1) }
    }

    private func identifyOrResetUserProfile(
        credential: UserCredentialProtocol?,
        notificationAuthStatus: PushNotificationAuthorizationCoordinator.Status
    ) {
        if let credential = credential {
            service.identify(
                AnalyticsUserProfile(
                    id: credential.userId,
                    name: credential.name,
                    email: credential.email,
                    accessibilitySettings: accessibilitySettings,
                    pushNotificationsAuthStatus: notificationAuthStatus
                )
            )
        } else {
            service.reset()
        }
    }
}
