import SwiftUI

@main
struct App: SwiftUI.App {
    private enum Const {
        static let launchScreenDebugMode = false
        static let launchScreenDelay = launchScreenDebugMode ? 5 : .durationMedium
    }

    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate

    init() {
        switch AppContext.current {
        case .test, .preview: return
        case .run, .release: break
        }
        clearLaunchScreenCache(Const.launchScreenDebugMode)
        allowAudioPlaybackOnSilentMode()
        configureAppearance()
        main()
    }

    final class Delegate: NSObject, UIApplicationDelegate {
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
        ) -> Bool {
            configureFirebase()
            configurePushNotifications(application: application)
            Thread.sleep(forTimeInterval: Const.launchScreenDelay)
            return true
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .onEvent(.sizeCategoryChanged, perform: configureAppearance)
                .onEvent(.appInBackground, perform: didEnterBackground)
        }
    }
}
