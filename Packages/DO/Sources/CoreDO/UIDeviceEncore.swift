import FoundationEncore
import class UIKit.UIDevice

public protocol UIDeviceProtocol {
    var systemName: String { get }
    var systemVersion: String { get }
}

extension UIDeviceProtocol {
    public var systemNameAndVersion: String {
        [systemName, systemVersion].spaced()
    }

    public var modelIdentifier: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let rawModelIdentifier = String(
            bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)),
            encoding: .ascii
        ) !! preconditionFailure("Failed to compute model identifier")
        return rawModelIdentifier.trimmingCharacters(in: .controlCharacters)
    }
}

extension UIDevice: UIDeviceProtocol {}

extension UIDeviceProtocol where Self == UIDevice {
    public static var current: Self { .current }
}
