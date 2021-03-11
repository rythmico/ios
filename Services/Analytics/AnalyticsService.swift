import Foundation
import class Mixpanel.MixpanelInstance
import typealias Mixpanel.Properties

protocol AnalyticsServiceProtocol {
    typealias Properties = Mixpanel.Properties

    func identify(distinctId: String)
    func time(event: String)
    func track(event: String?, properties: Properties?)
    func reset()
}

extension MixpanelInstance: AnalyticsServiceProtocol {
    func identify(distinctId: String) {
        identify(distinctId: distinctId, usePeople: true)
    }
}
