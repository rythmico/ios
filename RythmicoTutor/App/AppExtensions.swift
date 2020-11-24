import SwiftUI

extension App {
    static let id = "1519469319"
    static let logo = Asset.appLogo
    static let name = "Rythmico Tutor"
    static let slogan = "Turning kids into the festival headliners of tomorrow"
    static let distributionMethod = DistributionMethod.testFlight

    static func didFinishLaunching() {}

    func didEnterBackground() {
        Current.sharedCoordinator(for: \.bookingsFetchingService)?.reset()
        Current.sharedCoordinator(for: \.bookingRequestFetchingService)?.reset()
        Current.sharedCoordinator(for: \.bookingApplicationFetchingService)?.reset()
    }
}

extension SwiftUI.App {
    func configureAppearance() {}
}
