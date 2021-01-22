import Foundation

private enum UserDefaultsKey: String {
    case tutorVerified
}

private extension UserDefaultsProtocol {
    func object(forKey key: UserDefaultsKey) -> Any? { object(forKey: key.rawValue) }
    func set(_ value: Any?, forKey key: UserDefaultsKey) { set(value, forKey: key.rawValue) }
}

extension UserDefaultsProtocol {
    var tutorVerified: Bool {
        get { object(forKey: .tutorVerified) as? Bool ?? false }
        set { set(newValue, forKey: .tutorVerified) }
    }
}
