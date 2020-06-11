import UIKit

protocol PushNotificationRegisterServiceProtocol {
    func registerForRemoteNotifications()
    func unregisterForRemoteNotifications()
}

extension UIApplication: PushNotificationRegisterServiceProtocol {}
