import Foundation
import UserNotifications

protocol UNNotificationSettingsProtocol {
    var authorizationStatus: UNAuthorizationStatus { get }
}

extension UNNotificationSettings: UNNotificationSettingsProtocol {}

protocol UNUserNotificationCenterProtocol {
    func getNotificationSettings(completionHandler: @escaping (UNNotificationSettingsProtocol) -> Void)
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
}

extension UNUserNotificationCenter: UNUserNotificationCenterProtocol {
    func getNotificationSettings(completionHandler: @escaping (UNNotificationSettingsProtocol) -> Void) {
        getNotificationSettings { completionHandler($0 as UNNotificationSettings) }
    }
}
