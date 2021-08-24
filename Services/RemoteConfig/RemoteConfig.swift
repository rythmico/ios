import FoundationEncore

enum RemoteConfigKey: String {
    case appUpdateRequired = "app_update_required"
}

protocol RemoteConfigProtocol {
    var appUpdateRequired: Bool { get }
}

extension RemoteConfig {
    var appUpdateRequired: Bool {
        value(for: .appUpdateRequired).boolValue
    }
}
