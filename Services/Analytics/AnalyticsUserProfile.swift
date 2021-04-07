import UIKit
import FoundationSugar

struct AnalyticsUserProfile {
    var id: String
    var name: String?
    var email: String?
}

extension AnalyticsUserProfile {
    @AnalyticsPropsBuilder
    var rawAnalyticsValue: AnalyticsProps {
        if let name = name?.nilIfEmpty {
            ["$name": name]
        }
        if let email = email?.nilIfEmpty {
            ["$email": email]
        }
    }
}
