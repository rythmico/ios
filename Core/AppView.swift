import SwiftUIEncore

struct AppView: View {
    enum Const {
        static let defaultFadeOutAnimationDelay: Double = 0.5
        static let defaultFadeOutAnimationDuration: Double = .durationShort
        static let defaultFadeOutAnimationElapseTime: Double = defaultFadeOutAnimationDelay + defaultFadeOutAnimationDuration

        static let splashToOnboardingAnimationDelay: Double = 1
        static let splashToOnboardingAnimationDuration: Double = .durationLong
        static let splashToOnboardingAnimationElapseTime: Double = splashToOnboardingAnimationDelay + splashToOnboardingAnimationDuration
    }

    enum Screen {
        case splash
        case update
        case root(RootViewFlow)
    }

    @StateObject
    private var appStatus = Current.appStatus

    init() {
        // Waits for main window to come into existence.
        DispatchQueue.main.async(execute: Self.refreshAppearance)
    }

    var body: some View {
        ZStack {
            switch screen {
            case .splash:
                AnimatedAppSplash(image: App.logo, title: App.name)
            case .update:
                AppUpdatePrompt(appId: App.id, appName: App.name)
            case .root(let flow):
                RootView(flow: flow)
            }
        }
        .onAppEvent(.sizeCategoryChanged, perform: Self.refreshAppearance)
        .animation(animation, value: screen)
    }

    private var screen: Screen {
        if appStatus.isAppOutdated {
            return .update
        } else {
            return .root(RootViewFlow())
        }
    }

    private var animation: Animation {
        switch screen {
        case .splash, .update:
            return defaultFadeOutAnimation
        case .root(let flow):
            if flow.step == .onboarding {
                return splashToOnboardingAnimation
            } else {
                return defaultFadeOutAnimation
            }
        }
    }

    private var defaultFadeOutAnimation: Animation {
        .rythmicoSpring(duration: Const.defaultFadeOutAnimationDuration).delay(Const.defaultFadeOutAnimationDelay)
    }

    private var splashToOnboardingAnimation: Animation {
        .rythmicoSpring(duration: Const.splashToOnboardingAnimationDuration).delay(Const.splashToOnboardingAnimationDelay)
    }

    private static func refreshAppearance() {
        if let mainWindow = UIApplication.shared.windows.first {
            App.configureAppearance(for: mainWindow)

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
}

extension AppView.Screen: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.tag == rhs.tag
    }

    private var tag: AnyEquatable {
        switch self {
        case .splash:
            return .init(enumTag(Self.splash))
        case .update:
            return .init(enumTag(Self.update))
        case .root(let flow):
            return .init(flow.step)
        }
    }
}
