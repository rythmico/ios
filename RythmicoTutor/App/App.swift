import UIKit

struct App {
    static func main() {}
    static func refresh() {}

    static func handle(_ event: PushNotificationEvent) {
        Current.pushNotificationEventHandler.handle(event)
    }

    static func willResignActive() {
        Current.coordinator(for: \.bookingRequestFetchingService)?.reset()
        Current.coordinator(for: \.bookingApplicationFetchingService)?.reset()
    }
}
