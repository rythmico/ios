import FoundationEncore
import Combine

class UserCredentialProviderBase: ObservableObject {
    @Published var userCredential: UserCredential?
}

final class UserCredentialProvider: UserCredentialProviderBase {
    private let keychain: KeychainProtocol

    init(keychain: KeychainProtocol) {
        self.keychain = keychain
        super.init()
        self.userCredential = keychain.userCredential
    }

    override var userCredential: UserCredential? {
        willSet {
            if userCredential != newValue {
                keychain.userCredential = newValue
            }
        }
    }
}
