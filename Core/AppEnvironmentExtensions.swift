import Foundation

extension AppEnvironment {
    func coordinator<Request: AuthorizedAPIRequest>(for service: KeyPath<AppEnvironment, APIServiceBase<Request>>) -> APIActivityCoordinator<Request>? {
        accessTokenProviderObserver.currentProvider.map {
            APIActivityCoordinator(accessTokenProvider: $0, deauthenticationService: deauthenticationService, service: self[keyPath: service])
        }
    }

    func deviceRegisterCoordinator() -> DeviceRegisterCoordinator? {
        coordinator(for: \.deviceRegisterService).map {
            DeviceRegisterCoordinator(deviceTokenProvider: deviceTokenProvider, apiCoordinator: $0)
        }
    }

    func deviceUnregisterCoordinator() -> DeviceUnregisterCoordinator {
        DeviceUnregisterCoordinator(deviceTokenDeleter: deviceTokenDeleter)
    }
}

// Modifiers (debug-only)
extension AppEnvironment {
    mutating func userAuthenticated() {
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(
            currentProvider: AuthenticationAccessTokenProviderStub(result: .success("ACCESS_TOKEN"))
        )
    }

    mutating func userUnauthenticated() {
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverDummy()
    }
}
