import TutorDTO

final class APIEventHandler: APIEventHandlerProtocol {
    func handle(_ event: APIEvent) {
        switch event {
        case .unknown:
            break
        case .bookingRequestsChanged:
            Current.bookingRequestFetchingCoordinator.reset()
        case .bookingApplicationsChanged:
            Current.bookingApplicationFetchingCoordinator.reset()
        }
    }
}
