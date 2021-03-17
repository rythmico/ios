import Foundation
import FoundationSugar
import class Mixpanel.MixpanelInstance
import typealias Mixpanel.Properties

protocol AnalyticsServiceProtocol {
    typealias Properties = Mixpanel.Properties

    func identify(distinctId: String)
    func set(name: String?, email: String?)
    func time(event: String)
    func track(event: String?, properties: Properties?)
    func reset()
}

extension MixpanelInstance: AnalyticsServiceProtocol {
    func identify(distinctId: String) {
        identify(distinctId: distinctId, usePeople: true)
    }

    func set(name: String?, email: String?) {
        people.set(properties: Properties {
            if let name = name?.nilIfEmpty {
                ["$name": name]
            }
            if let email = email?.nilIfEmpty {
                ["$email": email]
            }
        })
    }
}
