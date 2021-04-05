import SwiftUI
import Stripe
import Then

extension App {
    static let id = "1493135894"
    static let logo = Asset.appLogo
    static let name = "Rythmico"
    static let slogan = "Turning kids into the festival headliners of tomorrow"
    static let distributionMethod = DistributionMethod.testFlight

    static func didFinishLaunching() {
        StripeAPI.defaultPublishableKey = AppSecrets.stripePublishableKey
    }

    func didEnterBackground() {
        Current.lessonPlanFetchingCoordinator.reset()
    }
}

extension SwiftUI.App {
    // TODO: hopefully to be deleted someday if SwiftUI allows for better customization.
    func configureAppearance() {
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

                let backIndicatorImage = UIImage(systemSymbol: .chevronLeft).applyingSymbolConfiguration(.init(pointSize: 17, weight: .medium))
                $0.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)
                $0.backButtonAppearance.normal.titleTextAttributes = [.font: UIFont.rythmicoFont(.bodyMedium)]

                bar.standardAppearance = $0
                bar.compactAppearance = $0
                bar.scrollEdgeAppearance = $0

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
    }
}
