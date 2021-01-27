import Foundation

final class APIActivityErrorHandler: APIActivityErrorHandlerProtocol {
    private let remoteConfigCoordinator: RemoteConfigCoordinator

    init(remoteConfigCoordinator: RemoteConfigCoordinator) {
        self.remoteConfigCoordinator = remoteConfigCoordinator
    }

    func handle(_ error: RythmicoAPIError) {
        switch error.errorType {
        case .unknown, .none:
            break
        case .appOutdated:
            remoteConfigCoordinator.fetch(forced: true)
        }
    }
}
