import FoundationEncore
#if RYTHMICO
import StudentDTO
#elseif TUTOR
import TutorDTO
#endif

final class APIEventHandlerSpy: APIEventHandlerProtocol {
    private(set) var latestEvent: APIEvent?

    func handle(_ event: APIEvent) {
        self.latestEvent = event
    }
}

final class APIEventHandlerDummy: APIEventHandlerProtocol {
    func handle(_ event: APIEvent) {}
}
