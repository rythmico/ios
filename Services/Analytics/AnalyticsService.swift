import FoundationEncore
import Amplitude

protocol AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile)
    func update(_ props: AnalyticsEvent.Props)
    func track(_ event: AnalyticsEvent)
    func reset()
}

func AnalyticsService() -> AnalyticsServiceProtocol { Amplitude.instance() }

extension Amplitude: AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {
        setUserId(profile.id)
        setUserProperties(profile.rawAnalyticsValue)
    }

    func update(_ props: AnalyticsEvent.Props) {
        setUserProperties(props)
    }

    func track(_ event: AnalyticsEvent) {
        logEvent(event.name.rawValue, withEventProperties: event.props)
    }

    func reset() {
        setUserId(nil)
    }
}
