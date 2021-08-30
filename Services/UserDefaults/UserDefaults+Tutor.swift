import FoundationEncore

extension UserDefaults {
    @objc dynamic var tutorVerified: Bool {
        get { get(default: false) }
        set { set(newValue) }
    }
}
