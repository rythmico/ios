// TODO: consider moving out into `SettingsClient` struct module when adopting TCA

extension UserDefaults {
    @_disfavoredOverload
    public func get<T>(_ key: String = #function) -> T? {
        object(forKey: key) as? T
    }

    @_disfavoredOverload
    public func get<T>(_ key: String = #function, default: T) -> T {
        get(key) ?? `default`
    }

    @_disfavoredOverload
    public func set<T>(_ newValue: T, for key: String = #function) {
        set(newValue, forKey: key)
    }

    @_disfavoredOverload
    public func set<T>(_ newValue: T?, for key: String = #function) {
        if let newValue = newValue {
            set(newValue, for: key)
        } else {
            removeObject(forKey: key)
        }
    }
}

extension UserDefaults {
    public static var live: UserDefaults {
        standard
    }

    public static var fake: UserDefaults {
        UserDefaultsMock(
            get: { key, memory in memory[key] },
            set: { value, key, memory in memory[key] = value },
            remove: { key, memory in memory.removeValue(forKey: key) }
        )
    }

    public static var noop: UserDefaults {
        UserDefaultsMock(
            get: { _, _ in nil },
            set: { _, _, _ in },
            remove: { _, _ in }
        )
    }
}

final class UserDefaultsMock: UserDefaults {
    typealias GetObject = (_ key: String, _ memory: [String: Any]) -> Any?
    typealias SetObject = (_ object: Any?, _ key: String, _ memory: inout [String: Any]) -> Void
    typealias RemoveObject = (_ key: String, _ memory: inout [String: Any]) -> Void

    let get: GetObject
    let set: SetObject
    let remove: RemoveObject

    private(set) var inMemoryDefaults: [String: Any] = [:]

    init(get: @escaping GetObject, set: @escaping SetObject, remove: @escaping RemoveObject) {
        self.get = get
        self.set = set
        self.remove = remove
        super.init(suiteName: "dev.davidroman.foundation-encore")!
    }

    override func object(forKey defaultName: String) -> Any? {
        get(defaultName, inMemoryDefaults)
    }

    override func set(_ value: Any?, forKey defaultName: String) {
        set(value, defaultName, &inMemoryDefaults)
    }

    override func removeObject(forKey defaultName: String) {
        remove(defaultName, &inMemoryDefaults)
    }
}
