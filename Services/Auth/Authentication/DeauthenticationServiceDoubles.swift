#if DEBUG
import Sugar

final class DeauthenticationServiceFake: DeauthenticationServiceProtocol {
    func deauthenticate() {
        Current.accessTokenProviderObserver.currentProvider = nil
    }
}

final class DeauthenticationServiceSpy: DeauthenticationServiceProtocol {
    var deauthenticationCount = 0

    func deauthenticate() {
        deauthenticationCount += 1
        Current.accessTokenProviderObserver.currentProvider = nil
    }
}

final class DeauthenticationServiceDummy: DeauthenticationServiceProtocol {
    func deauthenticate() {}
}
#endif
