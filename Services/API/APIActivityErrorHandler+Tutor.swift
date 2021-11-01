import FoundationEncore

final class APIActivityErrorHandler: APIActivityErrorHandlerProtocol {
    private let userCredentialProvider: UserCredentialProviderBase
    private let remoteConfigCoordinator: RemoteConfigCoordinator
    private let settings: UserDefaults

    init(
        userCredentialProvider: UserCredentialProviderBase,
        remoteConfigCoordinator: RemoteConfigCoordinator,
        settings: UserDefaults
    ) {
        self.userCredentialProvider = userCredentialProvider
        self.remoteConfigCoordinator = remoteConfigCoordinator
        self.settings = settings
    }

    func handle(_ error: RythmicoAPIError) {
        switch error.reason {
        case .unknown, .none:
            break
        case .known(.clientOutdated):
            remoteConfigCoordinator.fetch(forced: true)
        case .known(.unauthorized):
            userCredentialProvider.userCredential = nil
        case .known(.tutorNotVerified):
            settings.tutorVerified = false
        }
    }
}
