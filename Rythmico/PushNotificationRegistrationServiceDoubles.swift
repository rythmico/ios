import Foundation

final class PushNotificationRegistrationServiceSpy: PushNotificationRegistrationServiceProtocol {
    var registerCount = 0

    func registerForPushNotifications() {
        registerCount += 1
    }
}

final class PushNotificationRegistrationServiceDummy: PushNotificationRegistrationServiceProtocol {
    func registerForPushNotifications() {
        // NO-OP
    }
}

final class PushNotificationUnregistrationServiceSpy: PushNotificationUnregistrationServiceProtocol {
    var unregisterCount = 0

    func unregisterForPushNotifications() {
        unregisterCount += 1
    }
}

final class PushNotificationUnregistrationServiceDummy: PushNotificationUnregistrationServiceProtocol {
    func unregisterForPushNotifications() {
        // NO-OP
    }
}
