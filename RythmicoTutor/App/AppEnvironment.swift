import Foundation
import Sugar
import Then

struct AppEnvironment {
    var date: () -> Date

    var calendar: Calendar
    var locale: Locale
    var timeZone: TimeZone

    var keychain: KeychainProtocol

    var appleAuthorizationService: AppleAuthorizationServiceProtocol
    var appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    var appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifying
    var authenticationService: AuthenticationServiceProtocol
    var deauthenticationService: DeauthenticationServiceProtocol

    var accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase

    var bookingRequestRepository: BookingRequestRepository
    var bookingRequestFetchingService: BookingRequestFetchingServiceProtocol

    var deviceTokenProvider: DeviceTokenProvider
    var deviceRegisterService: DeviceRegisterServiceProtocol
    var deviceTokenDeleter: DeviceTokenDeleter

    var keyboardDismisser: KeyboardDismisser
    var uiAccessibility: UIAccessibilityProtocol.Type
    var urlOpener: URLOpener
}

extension AppEnvironment {
    func dateFormatter(format: DateFormatter.Format) -> DateFormatter {
        DateFormatter().then {
            $0.calendar = calendar
            $0.locale = locale
            $0.timeZone = timeZone
            $0.setFormat(format)
        }
    }

    func relativeDateTimeFormatter(
        context: Formatter.Context,
        style: RelativeDateTimeFormatter.UnitsStyle
    ) -> RelativeDateTimeFormatter {
        RelativeDateTimeFormatter().then {
            $0.calendar = calendar
            $0.locale = locale
            $0.formattingContext = context
            $0.unitsStyle = style
        }
    }

    func bookingRequestFetchingCoordinator() -> BookingRequestFetchingCoordinator? {
        accessTokenProviderObserver.currentProvider.map {
            BookingRequestFetchingCoordinator(accessTokenProvider: $0, service: bookingRequestFetchingService, repository: bookingRequestRepository)
        }
    }

    func deviceRegisterCoordinator() -> DeviceRegisterCoordinator? {
        accessTokenProviderObserver.currentProvider.map {
            DeviceRegisterCoordinator(accessTokenProvider: $0, deviceTokenProvider: deviceTokenProvider, service: deviceRegisterService)
        }
    }

    func deviceUnregisterCoordinator() -> DeviceUnregisterCoordinator {
        DeviceUnregisterCoordinator(deviceTokenDeleter: deviceTokenDeleter)
    }
}
