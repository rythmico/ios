import UIKit
import Then

struct App {
    static func main() {
        configureGlobalAppearance()
    }

    static func refresh() {
        configureGlobalAppearance()
    }

    static func handle(_ event: PushNotificationEvent) {
        Current.pushNotificationEventHandler.handle(event)
    }

    static func didEnterBackground() {
        Current.sharedCoordinator(for: \.lessonPlanFetchingService)?.reset()
    }

    // TODO: hopefully to be deleted someday if SwiftUI allows for better customization.
    private static func configureGlobalAppearance() {
        UINavigationBar.appearance().do { bar in
            UINavigationBarAppearance().do {
                $0.configureWithOpaqueBackground()
                $0.largeTitleTextAttributes = [
                    .foregroundColor: UIColor.rythmicoForeground,
                    .font: UIFont.rythmicoFont(.largeTitle)
                ]
                $0.titleTextAttributes = [
                    .foregroundColor: UIColor.rythmicoForeground,
                    .font: UIFont.rythmicoFont(.subheadlineBold)
                ]
                $0.titlePositionAdjustment.vertical = 1
                $0.shadowColor = nil

                let backIndicatorImage = UIImage(systemSymbol: .chevronLeft).applyingSymbolConfiguration(.init(pointSize: 17, weight: .bold))
                $0.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)
                $0.backButtonAppearance.normal.titleTextAttributes = [.font: UIFont.rythmicoFont(.bodyMedium)]

                bar.standardAppearance = $0
                bar.compactAppearance = $0
                bar.scrollEdgeAppearance = $0

                bar.isTranslucent = false

                bar.layoutMargins.left = .spacingMedium
                bar.layoutMargins.right = .spacingMedium
            }
        }

        UITableView.appearance().do {
            $0.backgroundColor = .clear
        }

        UITabBar.appearance().do { bar in
            UITabBarAppearance().do {
                [
                    $0.compactInlineLayoutAppearance,
                    $0.inlineLayoutAppearance,
                    $0.stackedLayoutAppearance
                ].forEach {
                    $0.normal.iconColor = .rythmicoGray90
                    $0.normal.titleTextAttributes = [
                        .font: UIFont.rythmicoFont(.caption),
                        .foregroundColor: UIColor.rythmicoGray90
                    ]
                }
                bar.standardAppearance = $0
            }
        }

        UISwitch.appearance().do {
            $0.onTintColor = .rythmicoPurple
        }

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
