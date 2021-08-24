import FoundationEncore

extension AppOriginClient {
    static let appStore = Self(get: { .appStore })
    static let testFlight = Self(get: { .testFlight })
}
