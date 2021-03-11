import Mixpanel

extension App.Delegate {
    func configureMixpanel() {
        Mixpanel.initialize(token: AppSecrets.mixpanelProjectToken)
        Mixpanel.mainInstance().serverURL = "https://api-eu.mixpanel.com"

        // FIXME: lazy instantiation of coordinator due to a lack of customizable memberwise inits
        _ = Current.analytics
    }
}
