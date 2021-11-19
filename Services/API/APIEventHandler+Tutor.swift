import TutorDTO

final class APIEventHandler: APIEventHandlerProtocol {
    func handle(_ event: APIEvent) {
        switch event {
        case .unknown:
            break
        case .known(.bookingRequestsChanged):
            Current.lessonPlanRequestFetchingCoordinator.reset()
        case .known(.bookingApplicationsChanged):
            Current.bookingApplicationFetchingCoordinator.reset()
        }
    }
}
