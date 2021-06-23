import FoundationSugar
import UIKit

enum APIClientInfo {
    static let current = [
        "Client-Id": Bundle.main.id,
        "Client-Version": Bundle.main.version,
        "Client-Build": Bundle.main.buildNumber,
    ]
}

private extension Bundle {
    var id: String { infoValue(for: kCFBundleIdentifierKey) }
    var version: String { infoValue(for: "CFBundleShortVersionString" as CFString) }
    var buildNumber: String { infoValue(for: kCFBundleVersionKey) }

    private func infoValue(for key: CFString) -> String {
        let key = key as String
        let info = Bundle.main.infoDictionary !! fatalError("infoDictionary is nil for bundle: \(self)")
        let value = info[key] as? String !! fatalError("\(key) is nil for bundle: \(self)")
        return value
    }
}
