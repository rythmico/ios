import SwiftUI

extension App {
    static func didFinishLaunching() {}

    func didEnterBackground() {
        Current.sharedCoordinator(for: \.bookingRequestFetchingService)?.reset()
        Current.sharedCoordinator(for: \.bookingApplicationFetchingService)?.reset()
    }
}

extension SwiftUI.App {
    func configureAppearance() {}
}
