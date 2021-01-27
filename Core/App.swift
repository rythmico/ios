import SwiftUI

struct App: SwiftUI.App {
    private enum Const {
        static let launchScreenDebugMode = false
        static let launchScreenFadeOutDelay = AnimatedAppSplash.Const.animationDuration * 2
    }

    @UIApplicationDelegateAdaptor(Delegate.self)
    private var delegate
    @StateObject
    private var remoteConfigCoordinator = Current.remoteConfigCoordinator

    init() {
        configureAppearance()
    }

    final class Delegate: NSObject, UIApplicationDelegate {
        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
        ) -> Bool {
            clearLaunchScreenCache(Const.launchScreenDebugMode)
            allowAudioPlaybackOnSilentMode()
            configureFirebase()
            configurePushNotifications(application: application)
            App.didFinishLaunching()
            return true
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if shouldShowSplash {
                    AnimatedAppSplash(image: App.logo, title: App.name)
                } else if Current.remoteConfig.appUpdateRequired {
                    AppUpdatePrompt(appId: App.id, method: App.distributionMethod)
                } else {
                    RootView()
                        .onEvent(.sizeCategoryChanged, perform: refreshAppearance)
                        .onEvent(.appInBackground, perform: didEnterBackground)
                }
            }
            .onAppear { remoteConfigCoordinator.fetch() }
            .animation(Animation.easeInOut(duration: .durationShort).delay(Const.launchScreenFadeOutDelay), value: shouldShowSplash)
        }
    }

    private var shouldShowSplash: Bool {
        !remoteConfigCoordinator.wasFetched
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
