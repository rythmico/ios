import Foundation

final class PushNotificationEventHandler: PushNotificationEventHandlerProtocol {
    func handle(_ event: PushNotificationEvent) {
        switch event {
        case .bookingRequestsChanged:
            Current.bookingRequestFetchingCoordinator.reset()
        case .bookingApplicationsChanged:
            Current.bookingApplicationFetchingCoordinator.reset()
        }
    }
}
