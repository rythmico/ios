import CoreDTO
import UIKit

extension App.Delegate: UNUserNotificationCenterDelegate {
    func configurePushNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        guard let environment = RegisterAPNSTokenBody.Environment(from: .read()) else {
            print("[APNS] No embedded.mobileprovision file found, so APS environment could not be determined.")
            return
        }
        let deviceToken = deviceToken.map { String(format: "%02x", $0) }.joined()
        Current.registerAPNSTokenCoordinator.runToIdle(
            with: .init(body: .init(deviceToken: deviceToken, environment: environment))
        )
    }

    // Show notifications in-app (without badge).
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }

    // Handle notification taps.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        defer { completionHandler() }

        // TODO: parse and handle userInfo ~> Route
        // let userInfo = response.notification.request.content.userInfo
    }
}
