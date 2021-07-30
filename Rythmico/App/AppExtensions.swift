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
        UINavigationBar.appearance().do {
            UINavigationBarAppearance().with {
                $0.configureWithTransparentBackground()
                $0.largeTitleTextAttributes = .rythmicoTextAttributes(color: .clear, style: .largeTitle)
                $0.titleTextAttributes = .rythmicoTextAttributes(color: .clear, style: .subheadlineBold)
                $0.shadowColor = nil

                $0.setBackIndicatorImage(BackButton.uiImage, transitionMaskImage: BackButton.uiImage)
                $0.backButtonAppearance.normal.titleTextAttributes = .rythmicoTextAttributes(color: nil, style: .bodyMedium)
            }
            .assign(to: $0, \.standardAppearance)
            .assign(to: $0, \.compactAppearance)
            .assign(to: $0, \.scrollEdgeAppearance)
        }

        UITableView.appearance().do {
            $0.backgroundColor = .clear
        }

        UITabBar.appearance().do {
            UITabBarAppearance().with {
                $0.configureWithOpaqueBackground()
                $0.shadowImage = .dynamic(color: .rythmico.outline)
                $0.backgroundColor = .rythmico.background
                [
                    $0.compactInlineLayoutAppearance,
                    $0.inlineLayoutAppearance,
                    $0.stackedLayoutAppearance
                ].forEach {
                    $0.normal.iconColor = .rythmico.foreground
                    $0.normal.titleTextAttributes = .rythmicoTextAttributes(color: .rythmico.foreground, style: .caption)
                    $0.selected.titleTextAttributes = .rythmicoTextAttributes(color: nil, style: .caption)
                }
            }
            .assign(to: $0, \.standardAppearance)
        }

        UISwitch.appearance().do {
            $0.onTintColor = .rythmico.picoteeBlue
        }
    }
}
