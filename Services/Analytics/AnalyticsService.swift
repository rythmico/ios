import Foundation
import FoundationSugar
import Mixpanel

protocol AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile)
//    func time(event: String)
    func track(event: AnalyticsEvent)
    func reset()
}

func AnalyticsService() -> AnalyticsServiceProtocol { Mixpanel.mainInstance() }

extension MixpanelInstance: AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {
        identify(distinctId: profile.id, usePeople: true)
        people.set(properties: profile.rawAnalyticsValue)
    }

    func track(event: AnalyticsEvent) {
        track(event: event.name.rawValue, properties: event.props)
    }
}
