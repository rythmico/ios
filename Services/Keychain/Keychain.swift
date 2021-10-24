import FoundationEncore
import Valet

protocol KeychainProtocol: AnyObject {
    func setString(_ string: String, forKey key: String) throws
    func string(forKey key: String) throws -> String
    func setObject<T: Encodable>(_ object: T, forKey key: String) throws
    func object<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T
    func removeObject(forKey key: String) throws
}

extension KeychainProtocol {
    private func setOrRemoveString(_ string: String?, forKey key: String) throws {
        if let string = string {
            try setString(string, forKey: key)
        } else {
            try removeObject(forKey: key)
        }
    }

    private func setOrRemoveObject<T: Encodable>(_ object: T?, forKey key: String) throws {
        if let object = object {
            try setObject(object, forKey: key)
        } else {
            try removeObject(forKey: key)
        }
    }
}

private enum KeychainKey {
    // TODO: remove after successful API migration
    static let legacySIWAAuthorizationUserID = "appleAuthorizationUserId"
    static let siwaUserInfo = "siwaUserInfo"
    static let userCredential = "userCredential"
}

extension KeychainProtocol {
    /// Old SIWA authorization user ID. Used to present simplified welcome screen for re-authenticating.
    var legacySIWAAuthorizationUserID: String? {
        get { try? string(forKey: KeychainKey.legacySIWAAuthorizationUserID) }
        set { try? setOrRemoveString(newValue, forKey: KeychainKey.legacySIWAAuthorizationUserID) }
    }

    /// Sign in with Apple user info
    var siwaUserInfo: SIWACredential.UserInfo? {
        get { try? object(SIWACredential.UserInfo.self, forKey: KeychainKey.siwaUserInfo) }
        set { try? setOrRemoveObject(newValue, forKey: KeychainKey.siwaUserInfo) }
    }

    /// User credential
    var userCredential: UserCredential? {
        get { try? object(UserCredential.self, forKey: KeychainKey.userCredential) }
        set { try? setOrRemoveObject(newValue, forKey: KeychainKey.userCredential) }
    }
}

typealias Keychain = Valet

extension Keychain: KeychainProtocol {
    func setObject<T>(_ object: T, forKey key: String) throws where T : Encodable {
        try setObject(JSONEncoder().encode(object), forKey: key)
    }

    func object<T>(_ type: T.Type, forKey key: String) throws -> T where T : Decodable {
        try JSONDecoder().decode(type, from: object(forKey: key))
    }
}

extension Keychain {
    static var localKeychain = Keychain.valet(
        with: Identifier(nonEmpty: "local_keychain")!,
        accessibility: .afterFirstUnlockThisDeviceOnly
    )
}
