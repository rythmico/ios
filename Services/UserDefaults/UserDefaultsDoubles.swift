import Foundation

final class UserDefaultsFake: UserDefaultsProtocol {
    private var inMemoryDefaults: [String: Any] = [:]

    func object(forKey defaultName: String) -> Any? {
        inMemoryDefaults[defaultName]
    }

    func set(_ value: Any?, forKey defaultName: String) {
        inMemoryDefaults[defaultName] = value
    }
}

final class UserDefaultsDummy: UserDefaultsProtocol {
    func object(forKey defaultName: String) -> Any? { nil }
    func set(_ value: Any?, forKey defaultName: String) {}
}
