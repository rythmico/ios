import Foundation

final class PushNotificationEventHandler: PushNotificationEventHandlerProtocol {
    func handle(_ event: PushNotificationEvent) {
        switch event {
        case .bookingRequestsChanged:
            Current.sharedCoordinator(for: \.bookingRequestFetchingService)?.reset()
        case .bookingApplicationsChanged:
            Current.sharedCoordinator(for: \.bookingApplicationFetchingService)?.reset()
        }
    }
}
