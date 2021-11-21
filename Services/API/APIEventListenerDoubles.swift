import CoreDO
import FoundationEncore
import Combine

final class APIEventListenerDummy<APIEvent: APIEventProtocol>: APIEventListenerBase<APIEvent> {
    override func connectToWebSocket(with userCredential: UserCredential) -> AnyCancellable {
        AnyCancellable(CancellableDummy())
    }

    override func on(_ event: APIEvent) -> AnyPublisher<Void, Never> {
        Just(()).eraseToAnyPublisher()
    }
}

struct CancellableDummy: Cancellable {
    func cancel() {}
}
