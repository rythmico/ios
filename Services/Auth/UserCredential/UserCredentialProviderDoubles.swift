import Combine

final class UserCredentialProviderStub: UserCredentialProviderBase {
    init(userCredential: UserCredentialProtocol?) {
        super.init()
        self.userCredential = userCredential
    }
}

final class UserCredentialProviderDummy: UserCredentialProviderBase {}
