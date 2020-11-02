import SwiftUI

extension App {
    static let logo = Asset.appLogo
    static let name = "Rythmico Tutor"
    static let slogan = "Turning kids into the festival headliners of tomorrow"

    static func didFinishLaunching() {}

    func didEnterBackground() {
        Current.sharedCoordinator(for: \.bookingRequestFetchingService)?.reset()
        Current.sharedCoordinator(for: \.bookingApplicationFetchingService)?.reset()
    }
}

extension SwiftUI.App {
    func configureAppearance() {}
}
