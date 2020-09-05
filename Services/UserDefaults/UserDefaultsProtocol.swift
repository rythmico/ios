import Foundation

protocol UserDefaultsProtocol {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}

extension UserDefaultsProtocol {
    var isAppFirstOpen: Bool {
        get { object(forKey: UserDefaultsKey.isAppFirstOpen) as? Bool ?? false }
        set { set(newValue, forKey: UserDefaultsKey.isAppFirstOpen) }
    }
}

private enum UserDefaultsKey {
    static let isAppFirstOpen = "isAppFirstOpen"
}
