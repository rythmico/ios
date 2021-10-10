import StudentDTO

// TODO: make usage per-view instead of singleton. Potentially use Publishers.
final class PushNotificationEventHandler: PushNotificationEventHandlerProtocol {
    func handle(_ event: APIEvent) {
        switch event {
        case .unknown:
            break
        case .lessonPlansChanged:
            Current.lessonPlanFetchingCoordinator.reset()
        }
    }
}
