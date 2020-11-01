import Foundation
import Sugar

struct RemoteConfigStub: RemoteConfigServiceProtocol {
    var fetchingDelay: TimeInterval?
    var appUpdateRequired: Bool

    func fetch(completion: @escaping Action) {
        fetch(forced: false, completion: completion)
    }

    func fetch(forced: Bool, completion: @escaping Action) {
        if let fetchingDelay = fetchingDelay {
            DispatchQueue.main.asyncAfter(deadline: .now () + fetchingDelay) {
                completion()
            }
        } else {
            completion()
        }
    }
}

final class RemoteConfigDummy: RemoteConfigServiceProtocol {
    var appUpdateRequired: Bool = false

    func fetch(completion: @escaping Action) {}
    func fetch(forced: Bool, completion: @escaping Action) {}
}
