import Foundation
import Valet

protocol KeychainProtocol: AnyObject {
    func setString(_ string: String, forKey key: String) throws
    func string(forKey key: String) throws -> String
    func removeObject(forKey key: String) throws
}

extension KeychainProtocol {
    var appleAuthorizationUserId: String? {
        get { try? string(forKey: KeychainKey.appleAuthorizationUserId) }
        set { try? setOrRemoveString(newValue, forKey: KeychainKey.appleAuthorizationUserId) }
    }

    private func setOrRemoveString(_ string: String?, forKey key: String) throws {
        if let string = string {
            try setString(string, forKey: key)
        } else {
            try removeObject(forKey: key)
        }
    }
}

private enum KeychainKey {
    static let appleAuthorizationUserId = "appleAuthorizationUserId"
}

typealias Keychain = Valet

extension Keychain: KeychainProtocol {}
extension Keychain {
    static var localKeychain = Keychain.valet(
        with: Identifier(nonEmpty: "local_keychain")!,
        accessibility: .afterFirstUnlockThisDeviceOnly
    )
}
