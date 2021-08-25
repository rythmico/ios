import FoundationEncore
import FirebaseRemoteConfig

typealias FIRRemoteConfig = FirebaseRemoteConfig.RemoteConfig

protocol RemoteConfigServiceProtocol: RemoteConfigProtocol {
    func fetch(forced: Bool, completion: @escaping Action)
}

final class RemoteConfig: RemoteConfigServiceProtocol {
    private enum Const {
        #if DEBUG
        static let minimumFetchInterval: TimeInterval = 0
        #else
        static let minimumFetchInterval: TimeInterval = 12 * 3600 // 12h (recommended)
        #endif
        static let fetchTimeout: TimeInterval = 4 // seconds
    }

    private let config = FIRRemoteConfig.remoteConfig() => {
        $0.configSettings = RemoteConfigSettings() => {
            $0.minimumFetchInterval = Const.minimumFetchInterval
            $0.fetchTimeout = Const.fetchTimeout
        }
    }

    func fetch(forced: Bool, completion: @escaping Action) {
        config.configSettings.minimumFetchInterval = forced ? 0 : Const.minimumFetchInterval
        config.fetchAndActivate { [self] status, error in
            if let error = error {
                assertionFailure(error.legibleDescription)
            } else {
                config.ensureInitialized { error in
                    if let error = error {
                        assertionFailure(error.legibleDescription)
                    }
                }
            }
            completion()
        }
        config.configSettings.minimumFetchInterval = Const.minimumFetchInterval
    }
}

extension RemoteConfig {
    func value(for key: RemoteConfigKey) -> RemoteConfigValue {
        config.configValue(forKey: key.rawValue)
    }
}
