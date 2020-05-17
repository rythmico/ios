import UIKit
import Firebase

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: Window?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureFirebase()
        configurePushNotifications(for: application)
        configureGlobalAppearance()
        configureWindow()
        return true
    }

    private func configureFirebase() {
        FirebaseApp.configure()
    }
}
