#if DEBUG
import Foundation

extension PushNotificationAuthorizationCoordinator {
    static let dummy = PushNotificationAuthorizationCoordinator(
        center: UNUserNotificationCenterDummy(),
        registerService: PushNotificationRegisterServiceDummy()
    )
}
#endif
