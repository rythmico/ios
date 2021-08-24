import FoundationEncore

// TODO: make usage per-view instead of singleton. Potentially use Publishers.
final class PushNotificationEventHandler: PushNotificationEventHandlerProtocol {
    func handle(_ event: PushNotificationEvent) {
        switch event {
        case .lessonPlansChanged:
            Current.lessonPlanFetchingCoordinator.reset()
        }
    }
}
