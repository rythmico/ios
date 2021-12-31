extension RegisterAPNSTokenBody.Environment {
    public init?(from mobileProvision: MobileProvision?) {
        switch mobileProvision?.entitlements.apsEnvironment {
        case .development:
            self = .sandbox
        case .production:
            self = .production
        case .disabled, .none:
            return nil
        }
    }
}
