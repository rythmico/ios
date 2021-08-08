import SwiftUISugar

extension App {
    typealias ID = Tagged<Self, String>

    static let id: ID = "1519469319"
    static let logo = Asset.appLogo
    static let name = "Rythmico Tutor"
    static let slogan = "Turning kids into the festival headliners of tomorrow"

    static func didFinishLaunching() {}

    func didEnterBackground() {
        Current.bookingsFetchingCoordinator.reset()
        Current.bookingRequestFetchingCoordinator.reset()
        Current.bookingApplicationFetchingCoordinator.reset()
    }
}

extension SwiftUI.App {
    static func configureAppearance(for window: UIWindow) {}
}
