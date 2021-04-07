import Foundation
import class Mixpanel.MixpanelInstance
import typealias Mixpanel.Properties

/// Represents the most basic interface into our analytics tracking service, and it's used as the backbone of
/// our more opinionated `AnalyticsServiceProtocol` interface used to to abstract away Mixpanel implementation specifics.
protocol RawAnalyticsServiceProtocol {
    typealias Properties = Mixpanel.Properties

    func identify(distinctId: String)
    func set(_ properties: Properties)
    func time(event: String)
    func track(event: String?, properties: Properties?)
    func reset()
}

extension MixpanelInstance: RawAnalyticsServiceProtocol {
    func identify(distinctId: String) {
        identify(distinctId: distinctId, usePeople: true)
    }

    func set(_ properties: Properties) {
        people.set(properties: properties)
    }
}

extension MixpanelInstance: AnalyticsServiceProtocol {}
