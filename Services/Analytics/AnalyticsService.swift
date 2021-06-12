import Foundation
import FoundationSugar
import Amplitude

protocol AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile)
    func track(_ event: AnalyticsEvent)
    func reset()
}

func AnalyticsService() -> AnalyticsServiceProtocol { Amplitude.instance() }

extension Amplitude: AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {
        setUserId(profile.id)
        setUserProperties(profile.rawAnalyticsValue)
    }

    func track(_ event: AnalyticsEvent) {
        logEvent(event.name.rawValue, withEventProperties: event.props)
    }

    func reset() {
        setUserId(nil)
    }
}
