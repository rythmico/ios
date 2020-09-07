import UIKit
import FirebaseMessaging

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func configurePushNotifications(for application: UIApplication) {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.registerForRemoteNotifications()
    }

    // Show notifications in-app (without sound/vibration or badge).
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }

    // Handle notification arrival (usually silent).
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch application.applicationState {
        case .background, .inactive:
            completionHandler(.noData)
            return
        case .active:
            break
        @unknown default:
            break
        }

        PushNotificationEvent(userInfo: userInfo).map(App.handle)
    }

    // Handle notification tap.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // TODO: parse and handle response.notification.request.content.userInfo ~> Route
    }
}
