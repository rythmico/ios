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

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken) // TODO: post token to /v1/devices
    }

    // Show notifications in-app (without sound/vibration or badge).
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}
