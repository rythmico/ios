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
        case .clientOutdated:
            remoteConfigCoordinator.fetch(forced: true)
        case .unauthorized:
            userCredentialProvider.userCredential = nil
        case .tutorNotVerified:
            settings.tutorVerified = false
        }
    }
}
