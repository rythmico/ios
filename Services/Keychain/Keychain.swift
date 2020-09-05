import Foundation
import Valet

protocol KeychainProtocol: AnyObject {
    @discardableResult
    func set(string: String, forKey key: String) -> Bool
    func string(forKey key: String) -> String?
    @discardableResult
    func removeObject(forKey key: String) -> Bool
}

extension KeychainProtocol {
    var appleAuthorizationUserId: String? {
        get { string(forKey: KeychainKey.appleAuthorizationUserId) }
        set { setOrRemove(string: newValue, forKey: KeychainKey.appleAuthorizationUserId) }
    }

    private func setOrRemove(string: String?, forKey key: String) {
        if let string = string {
            set(string: string, forKey: key)
        } else {
            removeObject(forKey: key)
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
