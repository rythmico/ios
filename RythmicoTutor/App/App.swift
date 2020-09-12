import UIKit

struct App {
    static func main() {}
    static func refresh() {}

    static func handle(_ event: PushNotificationEvent) {
        Current.pushNotificationEventHandler.handle(event)
    }

    static func didEnterBackground() {
        Current.sharedCoordinator(for: \.bookingRequestFetchingService)?.reset()
        Current.sharedCoordinator(for: \.bookingApplicationFetchingService)?.reset()
    }
}
