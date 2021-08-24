import FoundationEncore
import enum Valet.KeychainError

final class KeychainFake: KeychainProtocol {
    private(set) var inMemoryStorage: [String: String] = [:]

    func setString(_ string: String, forKey key: String) throws {
        inMemoryStorage[key] = string
    }

    func string(forKey key: String) throws -> String {
        try inMemoryStorage[key] !! KeychainError.itemNotFound
    }

    func removeObject(forKey key: String) throws {
        inMemoryStorage[key] = nil
    }
}

final class KeychainDummy: KeychainProtocol {
    func setString(_ string: String, forKey key: String) throws {}
    func string(forKey key: String) throws -> String { throw KeychainError.itemNotFound }
    func removeObject(forKey key: String) throws {}
}
