import SwiftUIEncore
import Stripe

extension App {
    typealias ID = Tagged<Self, String>
    
    static let id: ID = "1493135894"
    static let logo = Asset.Logo.rythmico
    static let name = "Rythmico"
    static let slogan = "Turning kids into the festival headliners of tomorrow"

    static func didFinishLaunching() {
        StripeAPI.defaultPublishableKey = AppSecrets.stripePublishableKey
    }

    func didEnterBackground() {
        Current.lessonPlanFetchingCoordinator.reset()
    }
}

extension SwiftUI.App {
    // TODO: hopefully to be deleted someday if SwiftUI allows for this customization.
    static func configureAppearance(for window: UIWindow) {
        UINavigationBar.appearance() => {
            UINavigationBarAppearance() => {
                $0.configureWithTransparentBackground()
                $0.largeTitleTextAttributes = .rythmicoTextAttributes(color: .clear, style: .largeTitle)
                $0.titleTextAttributes = .rythmicoTextAttributes(color: .clear, style: .subheadlineBold)
                $0.shadowColor = nil

                $0.setBackIndicatorImage(UIImage.chevronLeft, transitionMaskImage: UIImage.chevronLeft)
                $0.backButtonAppearance.normal.titleTextAttributes = .rythmicoTextAttributes(color: nil, style: .bodyMedium)
            }
            => (assignTo: $0, \.standardAppearance)
            => (assignTo: $0, \.compactAppearance)
            => (assignTo: $0, \.scrollEdgeAppearance)
            => (assignTo: $0, \.compactScrollEdgeAppearance_iOS15)
        }

        UITableView.appearance() => {
            $0.backgroundColor = .clear
        }

        UITabBar.appearance() => {
            UITabBarAppearance() => {
                $0.configureWithOpaqueBackground()
                $0.shadowImage = .dynamic(color: .rythmico.outline)
                $0.backgroundColor = .rythmico.background
                [
                    $0.compactInlineLayoutAppearance,
                    $0.inlineLayoutAppearance,
                    $0.stackedLayoutAppearance
                ].forEach {
                    let hasBottomSafeArea = window.safeAreaInsets.bottom > 0
                    let barItemTitleVerticalOffset: CGFloat = hasBottomSafeArea ? -2 : -4

                    $0.normal.iconColor = .rythmico.textPlaceholder
                    $0.normal.titleTextAttributes = .rythmicoTextAttributes(color: .rythmico.textPlaceholder, style: .caption)
                    $0.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: barItemTitleVerticalOffset)

                    $0.selected.iconColor = .rythmico.picoteeBlue
                    $0.selected.titleTextAttributes = .rythmicoTextAttributes(color: .rythmico.picoteeBlue, style: .caption)
                    $0.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: barItemTitleVerticalOffset)
                }
            }
            => (assignTo: $0, \.standardAppearance)
            => (assignTo: $0, \.scrollEdgeAppearance_iOS15)
        }

        UISwitch.appearance() => {
            $0.onTintColor = .rythmico.picoteeBlue
        }
    }
}
