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

final class APIEventListener<APIEvent: APIEventProtocol>: APIEventListenerBase<APIEvent> where APIEvent: Hashable {
    private let session = URLSession(configuration: .default)
    private var listeners: [APIEvent: PassthroughSubject<Void, Never>] = [:]
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
        let clientInfo = APIClientInfo.current !! {
            preconditionFailure("Required client info is unavailable")
        }
        let urlComponents = apiBaseURLComponents => {
            $0.scheme = "wss"
            $0.path = $0.path + "/events"
        }
        let url = urlComponents.url !! {
            preconditionFailure("Could not create WebSocket URL from components: \(urlComponents)")
        }
        let request = URLRequest(url: url) => { request in
            request.allHTTPHeaderFields = Dictionary<String, String> {
                request.allHTTPHeaderFields ?? [:]
                ["Authorization": "Bearer " + userCredential.accessToken]
                clientInfo.encodeAsHTTPHeaders()
            }
        }
        let ws = WebSocket(request: request) => { ws in
            ws.onEvent = { [weak self] message in
                guard let self = self else { return }
                switch message {
                case .binary(let data):
                    do {
                        let event = try JSONDecoder().decode(APIEvent.self, from: data)
                        if let listener = self.listeners[event] {
                            listener.send()
                        }
                    } catch {
                        print("[WebSocket] Message decoding error: \(error)")
                    }
                    print("[WebSocket] Received data: \(String(decoding: data, as: UTF8.self))")
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
        if let existingListener = listeners[event] {
            return existingListener.eraseToAnyPublisher()
        } else {
            let subject = PassthroughSubject<Void, Never>()
            listeners[event] = subject
            return subject.eraseToAnyPublisher()
        }
    }

    deinit {
        task?.cancel()
        cancellable?.cancel()
    }
}
