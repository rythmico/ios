import UIKit
import Sugar

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: Window?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureFirebase()
        configurePushNotifications(for: application)
        configureGlobalAppearance()
        sleep(.durationShort)
        configureWindow()
        return true
    }
}
