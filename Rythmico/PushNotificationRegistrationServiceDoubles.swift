import Foundation

final class PushNotificationRegistrationServiceDummy: PushNotificationRegistrationServiceProtocol {
    func registerForPushNotifications() {
        // NO-OP
    }
}

final class PushNotificationUnregistrationServiceDummy: PushNotificationUnregistrationServiceProtocol {
    func unregisterForPushNotifications() {
        // NO-OP
    }
}
