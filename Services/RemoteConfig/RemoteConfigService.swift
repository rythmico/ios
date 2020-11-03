import FirebaseRemoteConfig
import Sugar
import Then

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

    private let config = FIRRemoteConfig.remoteConfig().then {
        $0.configSettings = RemoteConfigSettings().then {
            $0.minimumFetchInterval = Const.minimumFetchInterval
            $0.fetchTimeout = Const.fetchTimeout
        }
    }

    func fetch(forced: Bool, completion: @escaping Action) {
        config.configSettings.minimumFetchInterval = forced ? 0 : Const.minimumFetchInterval
        config.fetchAndActivate { [self] status, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            } else {
                config.ensureInitialized {
                    $0.map { assertionFailure($0.localizedDescription) }
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
