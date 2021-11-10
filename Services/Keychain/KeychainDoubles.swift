import FoundationEncore
import enum Valet.KeychainError

final class KeychainFake: KeychainProtocol {
    private(set) var inMemoryStorage: [String: Any] = [:]

    func setString(_ string: String, forKey key: String) throws {
        inMemoryStorage[key] = string
    }

    func string(forKey key: String) throws -> String {
        try inMemoryStorage[key] as? String ?! KeychainError.itemNotFound
    }

    func setObject<T>(_ object: T, forKey key: String) throws where T : Encodable {
        inMemoryStorage[key] = object
    }

    func object<T>(_ type: T.Type, forKey key: String) throws -> T where T : Decodable {
        try inMemoryStorage[key] as? T ?! KeychainError.itemNotFound
    }

    func removeObject(forKey key: String) throws {
        inMemoryStorage[key] = nil
    }

    func removeAllObjects() throws {
        inMemoryStorage = [:]
    }
}

final class KeychainDummy: KeychainProtocol {
    func setString(_ string: String, forKey key: String) throws {}
    func string(forKey key: String) throws -> String { throw KeychainError.itemNotFound }
    func setObject<T>(_ object: T, forKey key: String) throws where T : Encodable {}
    func object<T>(_ type: T.Type, forKey key: String) throws -> T where T : Decodable { throw KeychainError.itemNotFound }
    func removeObject(forKey key: String) throws {}
    func removeAllObjects() throws {}
}
