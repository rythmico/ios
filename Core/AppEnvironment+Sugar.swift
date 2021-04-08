import UIKit
import Firebase
import Mixpanel
import Then
import enum APIKit.SessionTaskError

extension AppEnvironment {
    /// Simple wrapper to initialize AppEnvironment.live
    /// while ensuring all SDKs are configured as early as possible.
    static func initLive(_ build: () -> AppEnvironment) -> AppEnvironment {
        FirebaseApp.configure()

        Mixpanel.initialize(token: AppSecrets.mixpanelProjectToken)
        Mixpanel.mainInstance().serverURL = "https://api-eu.mixpanel.com"

        return build()
    }

    func calendar() -> Calendar {
        Calendar(identifier: calendarType()).with {
            $0.locale = locale
            $0.timeZone = timeZone
        }
    }

    func numberFormatter(format: NumberFormatter.Format) -> NumberFormatter {
        NumberFormatter().then {
            $0.locale = locale
            $0.setFormat(format)
        }
    }

    func dateFormatter(format: DateFormatter.Format) -> DateFormatter {
        DateFormatter().then {
            $0.calendar = calendar()
            $0.locale = locale
            $0.timeZone = timeZone
            $0.setFormat(format)
        }
    }

    func dateIntervalFormatter(format: DateIntervalFormatter.Format) -> DateIntervalFormatter {
        DateIntervalFormatter().then {
            $0.calendar = calendar()
            $0.locale = locale
            $0.timeZone = timeZone
            $0.setFormat(format)
        }
    }

    func dateComponentsFormatter(
        allowedUnits: NSCalendar.Unit,
        style: DateComponentsFormatter.UnitsStyle,
        includesTimeRemainingPhrase: Bool = false
    ) -> DateComponentsFormatter {
        DateComponentsFormatter().then {
            $0.calendar = calendar()
            $0.allowedUnits = allowedUnits
            $0.unitsStyle = style
            $0.includesTimeRemainingPhrase = includesTimeRemainingPhrase
        }
    }

    func relativeDateTimeFormatter(
        context: Formatter.Context,
        style: RelativeDateTimeFormatter.UnitsStyle,
        precise: Bool
    ) -> RelativeDateTimeFormatter {
        RelativeDateTimeFormatter().then {
            $0.calendar = calendar()
            $0.locale = locale
            $0.formattingContext = context
            $0.unitsStyle = style
            $0.dateTimeStyle = precise ? .numeric : .named
        }
    }
}
