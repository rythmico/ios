import Foundation
import FoundationSugar
import class Mixpanel.MixpanelInstance

protocol AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile)
//    func time(event: String)
//    func track(event: String?, properties: Properties?)
    func reset()
}

extension MixpanelInstance: AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {
        identify(distinctId: profile.id, usePeople: true)
        people.set(properties: profile.rawAnalyticsValue)
    }
}
