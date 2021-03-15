import UIKit

struct AppEnvironment {
    var state: AppState

    var remoteConfigCoordinator: RemoteConfigCoordinator
    var remoteConfig: RemoteConfigServiceProtocol

    var date: () -> Date
    var calendarType: () -> Calendar.Identifier
    var locale: Locale
    var timeZone: TimeZone

    var eventEmitter: NotificationCenter

    var settings: UserDefaults
    var keychain: KeychainProtocol

    var appleAuthorizationService: AppleAuthorizationServiceProtocol
    var appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    var appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifying
    var authenticationService: AuthenticationServiceProtocol
    var deauthenticationService: DeauthenticationServiceProtocol
    var userCredentialProvider: UserCredentialProviderBase

    var analytics: AnalyticsCoordinator
    var analyticsService: AnalyticsServiceProtocol

    var apiActivityErrorHandler: APIActivityErrorHandlerProtocol

    var deviceRegisterCoordinator: DeviceRegisterCoordinator
    var deviceUnregisterCoordinator: DeviceUnregisterCoordinator

    var pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator
    var pushNotificationEventHandler: PushNotificationEventHandlerProtocol

    var calendarSyncCoordinator: CalendarSyncCoordinator

    var sceneState: () -> UIApplication.State
    var uiAccessibility: UIAccessibilityProtocol.Type
    var keyboardDismisser: KeyboardDismisser
    var urlOpener: URLOpener
    var router: RouterProtocol

    var imageLoadingCoordinator: () -> ImageLoadingCoordinator

    var tutorStatusFetchingCoordinator: APIActivityCoordinator<GetTutorStatusRequest>

    var bookingsRepository: Repository<Booking>
    var bookingsFetchingCoordinator: APIActivityCoordinator<BookingsGetRequest>

    var bookingRequestRepository: Repository<BookingRequest>
    var bookingRequestFetchingCoordinator: APIActivityCoordinator<BookingRequestsGetRequest>
    var bookingRequestApplyingCoordinator: () -> APIActivityCoordinator<BookingRequestApplyRequest>

    var bookingApplicationRepository: Repository<BookingApplication>
    var bookingApplicationFetchingCoordinator: APIActivityCoordinator<BookingApplicationsGetRequest>
    var bookingApplicationRetractionCoordinator: () -> APIActivityCoordinator<BookingApplicationsRetractRequest>

    init(
        state: AppState,

        remoteConfig: RemoteConfigServiceProtocol,

        date: @escaping () -> Date,
        calendarType: @escaping () -> Calendar.Identifier,
        locale: Locale,
        timeZone: TimeZone,

        eventEmitter: NotificationCenter,

        settings: UserDefaults,
        keychain: KeychainProtocol,

        appleAuthorizationService: AppleAuthorizationServiceProtocol,
        appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider,
        appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifying,
        authenticationService: AuthenticationServiceProtocol,
        deauthenticationService: DeauthenticationServiceProtocol,
        userCredentialProvider: UserCredentialProviderBase,

        analyticsService: AnalyticsServiceProtocol,

        deviceTokenProvider: DeviceTokenProvider,
        deviceRegisterService: APIServiceBase<AddDeviceRequest>,
        deviceTokenDeleter: DeviceTokenDeleter,

        pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator,
        pushNotificationEventHandler: PushNotificationEventHandlerProtocol,

        calendarSyncStatusProvider: CalendarSyncStatusProviderBase,
        calendarInfoFetchingService: APIServiceBase<GetCalendarInfoRequest>,

        sceneState: @escaping () -> UIApplication.State,
        uiAccessibility: UIAccessibilityProtocol.Type,
        keyboardDismisser: KeyboardDismisser,
        urlOpener: URLOpener,
        router: RouterProtocol,

        imageLoadingService: ImageLoadingServiceProtocol,

        tutorStatusFetchingService: APIServiceBase<GetTutorStatusRequest>,

        bookingsRepository: Repository<Booking>,
        bookingsFetchingService: APIServiceBase<BookingsGetRequest>,

        bookingRequestRepository: Repository<BookingRequest>,
        bookingRequestFetchingService: APIServiceBase<BookingRequestsGetRequest>,
        bookingRequestApplyingService: APIServiceBase<BookingRequestApplyRequest>,

        bookingApplicationRepository: Repository<BookingApplication>,
        bookingApplicationFetchingService: APIServiceBase<BookingApplicationsGetRequest>,
        bookingApplicationRetractionService: APIServiceBase<BookingApplicationsRetractRequest>
    ) {
        self.state = state

        let remoteConfigCoordinator = RemoteConfigCoordinator(service: remoteConfig)
        self.remoteConfigCoordinator = remoteConfigCoordinator
        self.remoteConfig = remoteConfig

        self.date = date
        self.calendarType = calendarType
        self.locale = locale
        self.timeZone = timeZone

        self.eventEmitter = eventEmitter

        self.settings = settings
        self.keychain = keychain

        self.appleAuthorizationService = appleAuthorizationService
        self.appleAuthorizationCredentialStateProvider = appleAuthorizationCredentialStateProvider
        self.appleAuthorizationCredentialRevocationNotifier = appleAuthorizationCredentialRevocationNotifier
        self.authenticationService = authenticationService
        self.deauthenticationService = deauthenticationService
        self.userCredentialProvider = userCredentialProvider

        self.analytics = AnalyticsCoordinator(service: analyticsService, userCredentialProvider: userCredentialProvider)
        self.analyticsService = analyticsService

        let apiActivityErrorHandler = APIActivityErrorHandler(remoteConfigCoordinator: remoteConfigCoordinator, settings: settings)
        self.apiActivityErrorHandler = apiActivityErrorHandler

        func coordinator<R: AuthorizedAPIRequest>(for service: APIServiceBase<R>) -> APIActivityCoordinator<R> {
            APIActivityCoordinator(
                userCredentialProvider: userCredentialProvider,
                deauthenticationService: deauthenticationService,
                errorHandler: apiActivityErrorHandler,
                service: service
            )
        }

        self.deviceRegisterCoordinator = DeviceRegisterCoordinator(deviceTokenProvider: deviceTokenProvider, apiCoordinator: coordinator(for: deviceRegisterService))
        self.deviceUnregisterCoordinator = DeviceUnregisterCoordinator(deviceTokenDeleter: deviceTokenDeleter)

        self.pushNotificationAuthorizationCoordinator = pushNotificationAuthorizationCoordinator
        self.pushNotificationEventHandler = pushNotificationEventHandler

        self.calendarSyncCoordinator = CalendarSyncCoordinator(
            calendarSyncStatusProvider: calendarSyncStatusProvider,
            calendarInfoFetchingCoordinator: coordinator(for: calendarInfoFetchingService),
            eventEmitter: eventEmitter,
            urlOpener: urlOpener
        )

        self.sceneState = sceneState
        self.uiAccessibility = uiAccessibility
        self.keyboardDismisser = keyboardDismisser
        self.urlOpener = urlOpener
        self.router = router

        self.imageLoadingCoordinator = { ImageLoadingCoordinator(service: imageLoadingService) }

        self.tutorStatusFetchingCoordinator = coordinator(for: tutorStatusFetchingService)

        self.bookingsRepository = bookingsRepository
        self.bookingsFetchingCoordinator = coordinator(for: bookingsFetchingService)

        self.bookingRequestRepository = bookingRequestRepository
        self.bookingRequestFetchingCoordinator = coordinator(for: bookingRequestFetchingService)
        self.bookingRequestApplyingCoordinator = { coordinator(for: bookingRequestApplyingService) }

        self.bookingApplicationRepository = bookingApplicationRepository
        self.bookingApplicationFetchingCoordinator = coordinator(for: bookingApplicationFetchingService)
        self.bookingApplicationRetractionCoordinator = { coordinator(for: bookingApplicationRetractionService) }
    }
}
