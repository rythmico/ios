import SwiftUISugar
import Stripe

extension App {
    static let id = "1493135894"
    static let logo = Asset.Logo.rythmico
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
            UINavigationBarAppearance().with {
                $0.configureWithTransparentBackground()
                $0.largeTitleTextAttributes = .rythmicoTextAttributes(color: .clear, style: .largeTitle)
                $0.titleTextAttributes = .rythmicoTextAttributes(color: .clear, style: .subheadlineBold)
                $0.shadowColor = nil

                $0.setBackIndicatorImage(BackButton.uiImage, transitionMaskImage: BackButton.uiImage)
                $0.backButtonAppearance.normal.titleTextAttributes = .rythmicoTextAttributes(color: nil, style: .bodyMedium)
            }
            .assign(to: bar, \.standardAppearance)
            .assign(to: bar, \.compactAppearance)
            .assign(to: bar, \.scrollEdgeAppearance)

            bar.layoutMargins.left = .grid(5)
            bar.layoutMargins.right = .grid(5)
        }

        UITableView.appearance().do {
            $0.backgroundColor = .clear
        }

        UITabBar.appearance().do { bar in
            UITabBarAppearance().with {
                $0.configureWithOpaqueBackground()
                $0.shadowImage = .dynamic(color: .rythmico.gray20)
                $0.backgroundColor = .rythmico.background
                [
                    $0.compactInlineLayoutAppearance,
                    $0.inlineLayoutAppearance,
                    $0.stackedLayoutAppearance
                ].forEach {
                    $0.normal.iconColor = .rythmico.gray90
                    $0.normal.titleTextAttributes = .rythmicoTextAttributes(color: .rythmico.gray90, style: .caption)
                    $0.selected.titleTextAttributes = .rythmicoTextAttributes(color: nil, style: .caption)
                }
            }
            .assign(to: bar, \.standardAppearance)
        }

        UISwitch.appearance().do {
            $0.onTintColor = .rythmico.purple
        }
    }
}
