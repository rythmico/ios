import FoundationSugar

final class RemoteConfigCoordinator: ObservableObject {
    private let service: RemoteConfigServiceProtocol

    @Published private(set) var wasFetched = false

    init(service: RemoteConfigServiceProtocol) {
        self.service = service
    }

    func fetch(forced: Bool = false) {
        service.fetch(forced: forced) { [self] in
            wasFetched = true
        }
    }
}

extension RemoteConfigCoordinator: Then {}
