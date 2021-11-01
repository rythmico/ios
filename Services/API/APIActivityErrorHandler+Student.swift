import FoundationEncore

final class APIActivityErrorHandler: APIActivityErrorHandlerProtocol {
    private let userCredentialProvider: UserCredentialProviderBase
    private let remoteConfigCoordinator: RemoteConfigCoordinator

    init(
        userCredentialProvider: UserCredentialProviderBase,
        remoteConfigCoordinator: RemoteConfigCoordinator
    ) {
        self.userCredentialProvider = userCredentialProvider
        self.remoteConfigCoordinator = remoteConfigCoordinator
    }

    func handle(_ error: RythmicoAPIError) {
        switch error.reason {
        case .unknown, .none:
            break
        case .known(.unauthorized):
            userCredentialProvider.userCredential = nil
        case .known(.clientOutdated):
            remoteConfigCoordinator.fetch(forced: true)
        }
    }
}
