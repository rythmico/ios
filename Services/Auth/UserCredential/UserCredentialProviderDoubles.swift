import Combine

final class UserCredentialProviderStub: UserCredentialProviderBase {
    init(userCredential: UserCredential?) {
        super.init()
        self.userCredential = userCredential
    }
}

final class UserCredentialProviderDummy: UserCredentialProviderBase {}
