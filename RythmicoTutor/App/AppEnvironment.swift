import Foundation

struct AppEnvironment {
    var state: AppState

    var remoteConfig: RemoteConfigServiceProtocol

    var date: () -> Date
    var calendarType: () -> Calendar.Identifier
    var locale: Locale
    var timeZone: TimeZone

    var eventEmitter: NotificationCenter

    var settings: UserDefaultsProtocol
    var keychain: KeychainProtocol

    var appleAuthorizationService: AppleAuthorizationServiceProtocol
    var appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    var appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifying
    var authenticationService: AuthenticationServiceProtocol
    var deauthenticationService: DeauthenticationServiceProtocol
    var accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase

    var deviceTokenProvider: DeviceTokenProvider
    var deviceRegisterService: APIServiceBase<AddDeviceRequest>
    var deviceTokenDeleter: DeviceTokenDeleter

    var pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator
    var pushNotificationEventHandler: PushNotificationEventHandlerProtocol

    var calendarInfoFetchingService: APIServiceBase<GetCalendarInfoRequest>

    var uiAccessibility: UIAccessibilityProtocol.Type
    var keyboardDismisser: KeyboardDismisser
    var urlOpener: URLOpener
    var router: RouterProtocol

    var imageLoadingService: ImageLoadingServiceProtocol

    var bookingsRepository: Repository<Booking>
    var bookingsFetchingService: APIServiceBase<BookingsGetRequest>

    var bookingRequestRepository: Repository<BookingRequest>
    var bookingRequestFetchingService: APIServiceBase<BookingRequestsGetRequest>
    var bookingRequestApplyingService: APIServiceBase<BookingRequestApplyRequest>

    var bookingApplicationRepository: Repository<BookingApplication>
    var bookingApplicationFetchingService: APIServiceBase<BookingApplicationsGetRequest>
    var bookingApplicationRetractionService: APIServiceBase<BookingApplicationsRetractRequest>
}
