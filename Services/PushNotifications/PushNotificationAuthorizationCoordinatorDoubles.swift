import FoundationEncore

extension PushNotificationAuthorizationCoordinator {
    static let dummy = PushNotificationAuthorizationCoordinator(
        center: UNUserNotificationCenterDummy(),
        registerService: PushNotificationRegisterServiceDummy()
    )
}
