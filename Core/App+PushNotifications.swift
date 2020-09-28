import UIKit
import FirebaseMessaging

extension App {
    func configurePushNotifications() {
        delegate.configurePushNotifications()
    }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    fileprivate func configurePushNotifications() {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }

    // Show notifications in-app (without sound/vibration or badge).
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }

    // Handle notification arrival (usually silent).
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        defer { completionHandler(.noData) }

        switch application.applicationState {
        case .background:
            return
        case .active, .inactive:
            break
        @unknown default:
            break
        }

        PushNotificationEvent(userInfo: userInfo).map(Current.pushNotificationEventHandler.handle)
    }

    // Handle notification tap.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // TODO: parse and handle response.notification.request.content.userInfo ~> Route
    }
}
