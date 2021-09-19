import FoundationEncore

final class APIActivityErrorHandler: APIActivityErrorHandlerProtocol {
    private let remoteConfigCoordinator: RemoteConfigCoordinator

    init(remoteConfigCoordinator: RemoteConfigCoordinator) {
        self.remoteConfigCoordinator = remoteConfigCoordinator
    }

    func handle(_ error: RythmicoAPIError) {
        switch error.reason {
        case .unknown, .none:
            break
        case .clientOutdated:
            remoteConfigCoordinator.fetch(forced: true)
        }
    }
}
