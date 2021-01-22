import Foundation

final class APIActivityErrorHandler: APIActivityErrorHandlerProtocol {
    private let remoteConfigCoordinator: RemoteConfigCoordinator
    private let settings: UserDefaultsProtocol

    init(
        remoteConfigCoordinator: RemoteConfigCoordinator,
        settings: UserDefaultsProtocol
    ) {
        self.remoteConfigCoordinator = remoteConfigCoordinator
        self.settings = settings
    }

    func handle(_ error: RythmicoAPIError) {
        switch error.errorType {
        case .unknown, .none:
            break
        case .appOutdated:
            remoteConfigCoordinator.fetch(forced: true)
        case .tutorNotVerified:
            settings.tutorVerified = false
        }
    }
}
