import Foundation

final class KeychainFake: KeychainProtocol {
    var inMemoryStorage: [String: String] = [:]

    func set(string: String, forKey key: String) -> Bool {
        inMemoryStorage[key] = string
        return true
    }

    func string(forKey key: String) -> String? {
        inMemoryStorage[key]
    }

    func removeObject(forKey key: String) -> Bool {
        inMemoryStorage[key] = nil
        return true
    }
}
