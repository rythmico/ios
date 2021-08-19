import SwiftUI

struct App: SwiftUI.App {
    private enum Const {
        static let splashDebugMode = false
    }

    @UIApplicationDelegateAdaptor(Delegate.self)
    private var delegate

    final class Delegate: NSObject, UIApplicationDelegate {
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        ) -> Bool {
            clearLaunchScreenCache(Const.splashDebugMode)
            allowAudioPlaybackOnSilentMode()
            configurePushNotifications(application: application)
            App.didFinishLaunching()
            return true
        }
    }

    var body: some Scene {
        WindowGroup {
            AppView().onEvent(.appInBackground, perform: didEnterBackground)
        }
    }
}
