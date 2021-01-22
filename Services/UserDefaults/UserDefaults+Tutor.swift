import Foundation

extension UserDefaults {
    enum Key: String {
        case tutorVerified
    }
}

extension UserDefaults {
    var tutorVerified: Bool {
        get { self[.tutorVerified] as? Bool ?? false }
        set { self[.tutorVerified] = newValue }
    }
}
