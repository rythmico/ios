import Foundation

protocol UserDefaultsProtocol {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}

extension UserDefaultsProtocol {
//    var x: Bool {
//        get { object(forKey: UserDefaultsKey.x) as? Bool ?? false }
//        set { set(newValue, forKey: UserDefaultsKey.x) }
//    }
}

private enum UserDefaultsKey {
//    static let x = "x"
}
