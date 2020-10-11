import Foundation
import UserNotifications

final class UNUserNotificationCenterStub: UNUserNotificationCenterProtocol {
    private struct NotificationSettings: UNNotificationSettingsProtocol {
        var authorizationStatus: UNAuthorizationStatus
    }

    var authorizationStatus: UNAuthorizationStatus
    var authorizationRequestResult: (Bool, Error?)

    init(
        authorizationStatus: UNAuthorizationStatus,
        authorizationRequestResult: (Bool, Error?)
    ) {
        self.authorizationStatus = authorizationStatus
        self.authorizationRequestResult = authorizationRequestResult
    }

    func getNotificationSettings(completionHandler: @escaping (UNNotificationSettingsProtocol) -> Void) {
        completionHandler(NotificationSettings(authorizationStatus: authorizationStatus))
    }

    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        completionHandler(authorizationRequestResult.0, authorizationRequestResult.1)
    }
}

final class UNUserNotificationCenterDummy: UNUserNotificationCenterProtocol {
    func getNotificationSettings(completionHandler: @escaping (UNNotificationSettingsProtocol) -> Void) {}
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {}
}
