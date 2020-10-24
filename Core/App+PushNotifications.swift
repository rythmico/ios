import UIKit
import FirebaseMessaging

extension App.Delegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func configurePushNotifications(application: UIApplication) {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // Handle silent notifications ("events"). This function catches all notification types.
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
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

    // Show notifications in-app (without sound/vibration or badge).
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        defer { completionHandler([.list, .banner]) }

        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }

    // Handle foreground/background notification taps.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        defer { completionHandler() }

        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)

        // TODO: parse and handle userInfo ~> Route
    }
}
