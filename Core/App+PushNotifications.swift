import UIKit
#if RYTHMICO
import StudentDTO
#elseif TUTOR
import TutorDTO
#endif

extension App.Delegate: UNUserNotificationCenterDelegate {
    func configurePushNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let deviceToken = deviceToken.map { String(format: "%02x", $0) }.joined()
        Current.registerAPNSTokenCoordinator.runToIdle(with: .init(deviceToken: deviceToken))
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

        APIEvent(userInfo: userInfo).map(Current.apiEventHandler.handle)
    }

    // Show notifications in-app (without badge).
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }

    // Handle foreground/background notification taps.
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
