import UIKit
import FoundationSugar

struct AnalyticsUserProfile {
    var id: String
    var name: String?
    var email: String?
}

protocol AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile)
//    func time(event: String)
//    func track(event: String?, properties: Properties?)
    func reset()
}

extension AnalyticsServiceProtocol where Self: RawAnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {
        identify(distinctId: profile.id)
        set(Properties {
            if let name = profile.name?.nilIfEmpty {
                ["$name": name]
            }
            if let email = profile.email?.nilIfEmpty {
                ["$email": email]
            }
        })
    }
}
