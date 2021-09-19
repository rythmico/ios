import FoundationEncore

final class APIActivityErrorHandler: APIActivityErrorHandlerProtocol {
    private let remoteConfigCoordinator: RemoteConfigCoordinator
    private let settings: UserDefaults

    init(
        remoteConfigCoordinator: RemoteConfigCoordinator,
        settings: UserDefaults
    ) {
        self.remoteConfigCoordinator = remoteConfigCoordinator
        self.settings = settings
    }

    func handle(_ error: RythmicoAPIError) {
        switch error.reason {
        case .unknown, .none:
            break
        case .clientOutdated:
            remoteConfigCoordinator.fetch(forced: true)
        case .tutorNotVerified:
            settings.tutorVerified = false
        }
    }
}
