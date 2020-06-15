import UIKit
import Sugar

final class AppDelegate: UIResponder, UIApplicationDelegate {
    private enum Const {
        static let launchScreenDebugMode = false
        static let launchScreenDelay = launchScreenDebugMode ? 5 : .durationMedium
    }

    var window: Window?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        clearLaunchScreenCache(Const.launchScreenDebugMode)
        configureFirebase()
        configurePushNotifications(for: application)
        configureGlobalAppearance()
        sleep(Const.launchScreenDelay)
        configureWindow()
        return true
    }
}
