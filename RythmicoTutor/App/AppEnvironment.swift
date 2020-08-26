import Foundation

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

    var bookingRequestRepository: Repository<BookingRequest>
    var bookingRequestFetchingService: APIServiceBase<BookingRequestsGetRequest>
    var bookingRequestApplyingService: APIServiceBase<BookingRequestApplyRequest>

    var bookingApplicationRepository: Repository<BookingApplication>
    var bookingApplicationFetchingService: APIServiceBase<BookingApplicationsGetRequest>
    var bookingApplicationRetractionService: APIServiceBase<BookingApplicationsRetractRequest>

    var deviceTokenProvider: DeviceTokenProvider
    var deviceRegisterService: APIServiceBase<AddDeviceRequest>
    var deviceTokenDeleter: DeviceTokenDeleter

    var keyboardDismisser: KeyboardDismisser
    var uiAccessibility: UIAccessibilityProtocol.Type
    var urlOpener: URLOpener
    var mapOpener: MapOpenerProtocol

    var router: Router
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
}
