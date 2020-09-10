import UIKit

struct App {
    static func main() {}
    static func refresh() {}

    static func handle(_ event: PushNotificationEvent) {
        Current.pushNotificationEventHandler.handle(event)
    }

    static func willResignActive() {
        Current.sharedCoordinator(for: \.bookingRequestFetchingService)?.reset()
        Current.sharedCoordinator(for: \.bookingApplicationFetchingService)?.reset()
    }
}
