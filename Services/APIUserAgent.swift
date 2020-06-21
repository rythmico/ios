import Foundation
import UIKit

enum APIUserAgent {
    static let current: String? = {
        guard
            let info = Bundle.main.infoDictionary,
            let appIdentifier = info[kCFBundleIdentifierKey as String] as? String,
            let appVersion = info["CFBundleShortVersionString"] as? String,
            let appBuildNumber = info[kCFBundleVersionKey as String] as? String
        else {
            return nil
        }

        let model = UIDevice.current.modelIdentifier ?? "Unknown"
        let os = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion

        return "\(appIdentifier)/\(appVersion)/\(appBuildNumber) (\(model); \(os) \(osVersion))"
    }()
}

private extension UIDevice {
    var modelIdentifier: String? {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }

        var sysinfo = utsname()
        uname(&sysinfo)
        return String(
            bytes: Data(
                bytes: &sysinfo.machine,
                count: Int(_SYS_NAMELEN)
            ),
            encoding: .ascii
        )?.trimmingCharacters(in: .controlCharacters)
    }
}
