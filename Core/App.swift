import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    typealias PushNotificationEventHandler = (PushNotificationEvent) -> Void
    var pushNotificationEventHandler: PushNotificationEventHandler?
}

@main
struct App: SwiftUI.App {
    private enum Const {
        static let launchScreenDebugMode = false
        static let launchScreenDelay = launchScreenDebugMode ? 5 : .durationMedium
    }

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase

    init() {
        switch AppContext.current {
        case .test, .preview: return
        case .run, .release: break
        }
        clearLaunchScreenCache(Const.launchScreenDebugMode)
        allowAudioPlaybackOnSilentMode()
        configureAppearance()
        configureFirebase()
        configurePushNotifications()
        Thread.sleep(forTimeInterval: Const.launchScreenDelay)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .onEvent(.sizeCategoryChanged, perform: configureAppearance)
                .onEvent(.appInBackground, perform: didEnterBackground)
        }
        .onChange(of: scenePhase, perform: scenePhaseDidChange)
    }

    func scenePhaseDidChange(_ scenePhase: ScenePhase) {
        if scenePhase == .active {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
