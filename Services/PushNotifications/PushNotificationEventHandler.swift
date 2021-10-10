#if RYTHMICO
import StudentDTO
#elseif TUTOR
import TutorDTO
#endif

// TODO: use existentials in Swift 5.6
// https://github.com/apple/swift-evolution/blob/main/proposals/0309-unlock-existential-types-for-all-protocols.md

protocol PushNotificationEventHandlerProtocol {
    func handle(_ event: APIEvent)
}
