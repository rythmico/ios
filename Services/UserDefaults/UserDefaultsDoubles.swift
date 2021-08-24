import FoundationEncore

final class UserDefaultsFake: UserDefaults {
    private var inMemoryDefaults: [String: Any] = [:]

    override func object(forKey defaultName: String) -> Any? {
        inMemoryDefaults[defaultName]
    }

    override func set(_ value: Any?, forKey defaultName: String) {
        inMemoryDefaults[defaultName] = value
    }
}

final class UserDefaultsDummy: UserDefaults {
    override func object(forKey defaultName: String) -> Any? { nil }
    override func set(_ value: Any?, forKey defaultName: String) {}
}
