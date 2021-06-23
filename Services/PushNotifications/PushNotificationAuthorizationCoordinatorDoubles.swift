import FoundationSugar

extension PushNotificationAuthorizationCoordinator {
    static let dummy = PushNotificationAuthorizationCoordinator(
        center: UNUserNotificationCenterDummy(),
        registerService: PushNotificationRegisterServiceDummy()
    )
}
