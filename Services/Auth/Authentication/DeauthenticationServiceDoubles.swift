import FoundationEncore

final class DeauthenticationServiceFake: DeauthenticationServiceProtocol {
    func deauthenticate() {
        Current.userCredentialProvider.userCredential = nil
    }
}

final class DeauthenticationServiceSpy: DeauthenticationServiceProtocol {
    var deauthenticationCount = 0

    func deauthenticate() {
        deauthenticationCount += 1
        Current.userCredentialProvider.userCredential = nil
    }
}

final class DeauthenticationServiceDummy: DeauthenticationServiceProtocol {
    func deauthenticate() {}
}
