import FoundationEncore

final class PushNotificationRegisterServiceSpy: PushNotificationRegisterServiceProtocol {
    var registerCount = 0
    var unregisterCount = 0

    func registerForRemoteNotifications() {
        registerCount += 1
    }

    func unregisterForRemoteNotifications() {
        unregisterCount += 1
    }
}

final class PushNotificationRegisterServiceDummy: PushNotificationRegisterServiceProtocol {
    func registerForRemoteNotifications() {}
    func unregisterForRemoteNotifications() {}
}
