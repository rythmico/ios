import Foundation
import UIKit

enum APIClientInfo {
    static let current: [String: String] = {
        guard let info = Bundle.main.infoDictionary else {
            fatalError("Bundle.main.infoDictionary is nil.")
        }
        guard let appIdentifier = info[kCFBundleIdentifierKey as String] as? String else {
            fatalError("App Bundle ID is nil.")
        }
        guard let appVersion = info["CFBundleShortVersionString"] as? String else {
            fatalError("App Version is nil.")
        }
        guard let appBuildNumber = info[kCFBundleVersionKey as String] as? String else {
            fatalError("App Build Number is nil.")
        }
        return [
            "Client-Id": appIdentifier,
            "Client-Version": appVersion,
            "Client-Build": appBuildNumber,
        ]
    }()
}
