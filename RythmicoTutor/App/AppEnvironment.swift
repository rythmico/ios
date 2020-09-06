import Foundation

struct AppEnvironment {
    var date: () -> Date
    var calendar: Calendar
    var locale: Locale
    var timeZone: TimeZone

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

    var uiAccessibility: UIAccessibilityProtocol.Type
    var keyboardDismisser: KeyboardDismisser
    var urlOpener: URLOpener
    var mapOpener: MapOpenerProtocol
    var router: Router

    var imageLoadingService: ImageLoadingServiceProtocol

    var bookingRequestRepository: Repository<BookingRequest>
    var bookingRequestFetchingService: APIServiceBase<BookingRequestsGetRequest>
    var bookingRequestApplyingService: APIServiceBase<BookingRequestApplyRequest>

    var bookingApplicationRepository: Repository<BookingApplication>
    var bookingApplicationFetchingService: APIServiceBase<BookingApplicationsGetRequest>
    var bookingApplicationRetractionService: APIServiceBase<BookingApplicationsRetractRequest>
}
