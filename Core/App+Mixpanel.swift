import Mixpanel

extension App.Delegate {
    func configureMixpanel() {
        Mixpanel.initialize(token: AppSecrets.mixpanelProjectToken)
        Mixpanel.mainInstance().serverURL = "https://api-eu.mixpanel.com"
    }
}
