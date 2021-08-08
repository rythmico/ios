import FoundationSugar

extension AppOriginClient {
    static let appStore = Self(isTestFlightApp: { false })
    static let testFlight = Self(isTestFlightApp: { true })
}
