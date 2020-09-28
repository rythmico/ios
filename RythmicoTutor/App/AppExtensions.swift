import UIKit

extension App {
    func didEnterBackground() {
        Current.sharedCoordinator(for: \.bookingRequestFetchingService)?.reset()
        Current.sharedCoordinator(for: \.bookingApplicationFetchingService)?.reset()
    }

    func configureAppearance() {}
}
