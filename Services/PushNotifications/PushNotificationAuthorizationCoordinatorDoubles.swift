import Foundation

extension PushNotificationAuthorizationCoordinator {
    static let dummy = PushNotificationAuthorizationCoordinator(
        center: UNUserNotificationCenterDummy(),
        registerService: PushNotificationRegisterServiceDummy(),
        queue: nil
    )
}
