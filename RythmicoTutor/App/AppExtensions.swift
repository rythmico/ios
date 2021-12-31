import SwiftUIEncore

extension App {
    typealias ID = Tagged<Self, String>

    static let id: ID = "1519469319"
    static let logo = Asset.appLogo
    static let name = "Rythmico Tutor"
    static let slogan = "Turning kids into the festival headliners of tomorrow"

    static func didFinishLaunching() {}
}

extension SwiftUI.App {
    static func configureAppearance(for window: UIWindow) {
        UINavigationBar.appearance() => {
            UINavigationBarAppearance() => {
                $0.configureWithOpaqueBackground()
            }
            => (assignTo: $0, \.standardAppearance)
            => (assignTo: $0, \.compactAppearance)
            => (assignTo: $0, \.scrollEdgeAppearance)
            => (assignTo: $0, \.compactScrollEdgeAppearance_iOS15)
        }

        UITabBar.appearance() => {
            UITabBarAppearance() => {
                $0.configureWithOpaqueBackground()
            }
            => (assignTo: $0, \.standardAppearance)
            => (assignTo: $0, \.scrollEdgeAppearance_iOS15)
        }
    }
}
