import TutorDTO

final class APIEventHandler: APIEventHandlerProtocol {
    func handle(_ event: APIEvent) {
        switch event {
        case .unknown:
            break
        case .known(.lessonPlanRequestsChanged):
            Current.lessonPlanRequestFetchingCoordinator.reset()
        case .known(.bookingApplicationsChanged):
            Current.bookingApplicationFetchingCoordinator.reset()
        }
    }
}
