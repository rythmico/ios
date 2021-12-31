import Combine
import CoreDO
import FoundationEncore
import Starscream

// TODO: use existentials in Swift 5.6
// https://github.com/apple/swift-evolution/blob/main/proposals/0309-unlock-existential-types-for-all-protocols.md

class APIEventListenerBase<APIEvent: APIEventProtocol> {
    func connectToWebSocket(with userCredential: UserCredential) -> AnyCancellable {
        preconditionFailure("Do not instantiate APIEventListenerBase directly.")
    }

    func on(_ event: APIEvent) -> AnyPublisher<Void, Never> {
        preconditionFailure("Do not instantiate APIEventListenerBase directly.")
    }
}

final class APIEventListener<APIEvent: APIEventProtocol>: APIEventListenerBase<APIEvent> {
    private let session = URLSession(configuration: .default)
    private let subject = PassthroughSubject<APIEvent, Never>()
    private var task: AnyCancellable? = nil
    private var cancellable: AnyCancellable? = nil

    init(userCredentialProvider: UserCredentialProviderBase) {
        super.init()
        cancellable = userCredentialProvider.$userCredential.sink { [weak self] userCredential in
            guard let self = self else { return }
            if let userCredential = userCredential {
                self.task = self.connectToWebSocket(with: userCredential)
            } else {
                self.task?.cancel()
            }
        }
    }

    override func connectToWebSocket(with userCredential: UserCredential) -> AnyCancellable {
        let url = APIUtils.url(scheme: "wss", path: "/events")
        let request = URLRequest(url: url) => {
            $0.allHTTPHeaderFields = APIUtils.headers(bearer: userCredential, clientInfo: .current)
        }
        let ws = WebSocket(request: request) => { ws in
            ws.onEvent = { [weak self] message in
                guard let self = self else { return }
                switch message {
                case .binary(let data):
                    print("[WebSocket] Received data: \(String(decoding: data, as: UTF8.self))")
                    do {
                        let event = try JSONDecoder().decode(APIEvent.self, from: data)
                        self.subject.send(event)
                    } catch {
                        print("[WebSocket] Message decoding error: \(error)")
                    }
                case .cancelled, .reconnectSuggested(true):
                    print("[WebSocket] Connection dropped. Reconnecting...")
                    ws.connect()
                default:
                    print("[WebSocket] Received message: \(message)")
                }
            }
            ws.callbackQueue = DispatchQueue.main
            print("[WebSocket] Connecting to URL: \(url)")
            ws.connect()
        }
        return AnyCancellable(ws.forceDisconnect)
    }

    override func on(_ event: APIEvent) -> AnyPublisher<Void, Never> {
        subject.filter { $0 == event }.mapToVoid().eraseToAnyPublisher()
    }

    deinit {
        task?.cancel()
        cancellable?.cancel()
    }
}
