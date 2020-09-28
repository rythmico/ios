import UIKit

extension App {
    func handle(_ event: PushNotificationEvent) {
        Current.pushNotificationEventHandler.handle(event)
    }

    func didEnterBackground() {
        Current.sharedCoordinator(for: \.bookingRequestFetchingService)?.reset()
        Current.sharedCoordinator(for: \.bookingApplicationFetchingService)?.reset()
    }

    func configureAppearance() {}
}
