import FoundationSugar
import Combine
import FoundationSugar

class UserCredentialProviderBase: ObservableObject {
    @Published var userCredential: UserCredentialProtocol?
}

final class UserCredentialProvider: UserCredentialProviderBase {
    private let emitter: UserCredentialEmitterProtocol
    private var token: UserCredentialEmitterProtocol.ListenerToken?

    init(emitter: UserCredentialEmitterProtocol) {
        self.emitter = emitter
        super.init()
        self.userCredential = emitter.userCredential
        subscribeToEmitter()
    }

    private func subscribeToEmitter() {
        token = emitter.addStateDidChangeListener { [self] credential in
            userCredential = credential
        }
    }

    deinit {
        token.map(emitter.removeStateDidChangeListener)
    }
}
