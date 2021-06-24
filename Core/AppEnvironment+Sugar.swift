import SwiftUISugar
import Firebase
#if RYTHMICO
import Amplitude
#endif

extension AppEnvironment {
    /// Simple wrapper to initialize AppEnvironment.live
    /// while ensuring all SDKs are configured as early as possible.
    static func initLive(_ build: () -> AppEnvironment) -> AppEnvironment {
        #if RYTHMICO
        Amplitude.instance().do {
            $0.trackingSessionEvents = true
            $0.initializeApiKey(AppSecrets.amplitudeProjectToken)
        }
        #endif
        FirebaseApp.configure()
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
