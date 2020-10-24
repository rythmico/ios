import SwiftUI

@main
struct App: SwiftUI.App {
    private enum Const {
        static let launchScreenDebugMode = false
        static let launchScreenDelay = launchScreenDebugMode ? 5 : .durationMedium
    }

    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate

    init() {
        configureAppearance()
    }

    final class Delegate: NSObject, UIApplicationDelegate {
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
        ) -> Bool {
            switch AppContext.current {
            case .test, .preview: return true
            case .run, .release: break
            }
            clearLaunchScreenCache(Const.launchScreenDebugMode)
            allowAudioPlaybackOnSilentMode()
            configureFirebase()
            configurePushNotifications(application: application)
            App.didFinishLaunching()
            Thread.sleep(forTimeInterval: Const.launchScreenDelay)
            return true
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .onEvent(.sizeCategoryChanged, perform: refreshAppearance)
                .onEvent(.appInBackground, perform: didEnterBackground)
        }
    }

    private func refreshAppearance() {
        configureAppearance()

        for window in UIApplication.shared.windows {
            // Whenever a system keyboard is shown, a special internal window is created in application
            // window list of type UITextEffectsWindow. This kind of window cannot be safely removed without
            // having an adverse effect on keyboard behavior. For example, an input accessory view is
            // disconnected from the keyboard. Therefore, a check for this class is needed. In case this class
            // that is indernal is removed from the iOS SDK in future, there is a "fallback" class check on
            // NSString class that always fails.
            if !window.isKind(of: NSClassFromString("UITextEffectsWindow") ?? NSString.classForCoder()) {
                window.subviews.forEach {
                    $0.removeFromSuperview()
                    window.addSubview($0)
                }
            }
        }
    }
}
