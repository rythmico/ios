#if DEBUG
import Foundation

final class PushNotificationEventHandlerSpy: PushNotificationEventHandlerProtocol {
    private(set) var latestEvent: PushNotificationEvent?

    func handle(_ event: PushNotificationEvent) {
        self.latestEvent = event
    }
}

final class PushNotificationEventHandlerDummy: PushNotificationEventHandlerProtocol {
    func handle(_ event: PushNotificationEvent) {}
}
#endif
