import StudentDTO

// TODO: make usage per-view instead of singleton. Potentially use Publishers.
final class APIEventHandler: APIEventHandlerProtocol {
    func handle(_ event: APIEvent) {
        switch event {
        case .unknown:
            break
        case .known(.lessonPlansChanged):
            Current.lessonPlanFetchingCoordinator.reset()
        }
    }
}
