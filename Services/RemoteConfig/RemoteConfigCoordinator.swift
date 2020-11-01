import Foundation

final class RemoteConfigCoordinator: ObservableObject {
    private let service: RemoteConfigServiceProtocol

    @Published private(set) var wasFetched = false

    init(service: RemoteConfigServiceProtocol) {
        self.service = service
    }

    func fetch(forced: Bool = false) {
        service.fetch(forced: forced) { [self] in
            print("Is app update required: \(Current.remoteConfig.appUpdateRequired)")
            wasFetched = true
        }
    }
}
