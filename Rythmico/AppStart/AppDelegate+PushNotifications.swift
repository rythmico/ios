import UIKit
import FirebaseMessaging

extension AppDelegate: MessagingDelegate {
    func configurePushNotifications() {
        Messaging.messaging().delegate = self

    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken) // TODO: post token to /v1/devices
    }
}
