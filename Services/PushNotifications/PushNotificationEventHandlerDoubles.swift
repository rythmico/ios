import FoundationEncore
#if RYTHMICO
import StudentDTO
#elseif TUTOR
import TutorDTO
#endif

final class PushNotificationEventHandlerSpy: PushNotificationEventHandlerProtocol {
    private(set) var latestEvent: APIEvent?

    func handle(_ event: APIEvent) {
        self.latestEvent = event
    }
}

final class PushNotificationEventHandlerDummy: PushNotificationEventHandlerProtocol {
    func handle(_ event: APIEvent) {}
}
