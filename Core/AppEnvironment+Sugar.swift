#if RYTHMICO
import Amplitude
#endif
import AppCenter
import AppCenterCrashes
import SwiftUIEncore

extension AppEnvironment {
    /// Simple wrapper to initialize AppEnvironment.live
    /// while ensuring all SDKs are configured as early as possible.
    static func initLive(_ build: () -> AppEnvironment) -> AppEnvironment {
        #if RYTHMICO
        Amplitude.instance() => {
            $0.trackingSessionEvents = true
            $0.initializeApiKey(AppSecrets.amplitudeProjectToken)
        }
        #endif
        AppCenter.start(
            withAppSecret: AppSecrets.appCenterSecret,
            services: [Crashes.self]
        )
        return build()
    }

    func calendar() -> Calendar {
        Calendar(identifier: calendarType()) => {
            $0.locale = locale()
            $0.timeZone = timeZone()
        }
    }

    func numberFormatter(format: NumberFormatter.Format) -> NumberFormatter {
        NumberFormatter() => {
            $0.locale = locale()
            $0.setFormat(format)
        }
    }

    func dateFormatter(format: DateFormatter.Format) -> DateFormatter {
        DateFormatter() => {
            $0.calendar = calendar()
            $0.locale = locale()
            $0.timeZone = timeZone()
            $0.setFormat(format)
        }
    }

    func dateIntervalFormatter(format: DateIntervalFormatter.Format) -> DateIntervalFormatter {
        DateIntervalFormatter() => {
            $0.calendar = calendar()
            $0.locale = locale()
            $0.timeZone = timeZone()
            $0.setFormat(format)
        }
    }

    func dateComponentsFormatter(
        allowedUnits: NSCalendar.Unit,
        style: DateComponentsFormatter.UnitsStyle,
        includesTimeRemainingPhrase: Bool = false
    ) -> DateComponentsFormatter {
        DateComponentsFormatter() => {
            $0.calendar = calendar()
            $0.allowedUnits = allowedUnits
            $0.unitsStyle = style
            $0.includesTimeRemainingPhrase = includesTimeRemainingPhrase
        }
    }

    func listFormatter() -> ListFormatter {
        ListFormatter() => {
            $0.locale = locale()
        }
    }

    func relativeDateTimeFormatter(
        context: Formatter.Context,
        style: RelativeDateTimeFormatter.UnitsStyle,
        precise: Bool
    ) -> RelativeDateTimeFormatter {
        RelativeDateTimeFormatter() => {
            $0.calendar = calendar()
            $0.locale = locale()
            $0.formattingContext = context
            $0.unitsStyle = style
            $0.dateTimeStyle = precise ? .numeric : .named
        }
    }
}
