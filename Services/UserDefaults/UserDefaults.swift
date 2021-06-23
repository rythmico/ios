import FoundationSugar

extension UserDefaults {
    subscript(key: Key) -> Any? {
        get { object(forKey: key.rawValue) }
        set { set(newValue, forKey: key.rawValue) }
    }
}
