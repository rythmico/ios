import Foundation

struct AppEnvironment {
    var state: AppState

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
    var accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase

    var analytics: AnalyticsCoordinator
    var analyticsService: AnalyticsServiceProtocol

    var deviceTokenProvider: DeviceTokenProvider
    var deviceRegisterService: APIServiceBase<AddDeviceRequest>
    var deviceTokenDeleter: DeviceTokenDeleter

    var pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator
    var pushNotificationEventHandler: PushNotificationEventHandlerProtocol

    var calendarSyncStatusProvider: CalendarSyncStatusProviderBase
    var calendarInfoFetchingService: APIServiceBase<GetCalendarInfoRequest>

    var uiAccessibility: UIAccessibilityProtocol.Type
    var keyboardDismisser: KeyboardDismisser
    var urlOpener: URLOpener
    var router: RouterProtocol

    var imageLoadingService: ImageLoadingServiceProtocol

    var instrumentSelectionListProvider: InstrumentSelectionListProviderProtocol
    var addressSearchService: APIServiceBase<AddressSearchRequest>

    var lessonPlanFetchingService: APIServiceBase<GetLessonPlansRequest>
    var lessonPlanRequestService: APIServiceBase<CreateLessonPlanRequest>
    var lessonPlanCancellationService: APIServiceBase<CancelLessonPlanRequest>
    var lessonPlanGetCheckoutService: APIServiceBase<GetLessonPlanCheckoutRequest>
    var lessonPlanCompleteCheckoutService: APIServiceBase<CompleteLessonPlanCheckoutRequest>
    var lessonPlanRepository: Repository<LessonPlan>

    var lessonSkippingService: APIServiceBase<SkipLessonRequest>

    var portfolioFetchingService: APIServiceBase<GetPortfolioRequest>

    var cardSetupCredentialFetchingService: APIServiceBase<GetCardSetupCredentialRequest>
    var cardSetupService: CardSetupServiceProtocol

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
        accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase,

        analyticsService: AnalyticsServiceProtocol,

        deviceTokenProvider: DeviceTokenProvider,
        deviceRegisterService: APIServiceBase<AddDeviceRequest>,
        deviceTokenDeleter: DeviceTokenDeleter,

        pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator,
        pushNotificationEventHandler: PushNotificationEventHandlerProtocol,

        calendarSyncStatusProvider: CalendarSyncStatusProviderBase,
        calendarInfoFetchingService: APIServiceBase<GetCalendarInfoRequest>,

        uiAccessibility: UIAccessibilityProtocol.Type,
        keyboardDismisser: KeyboardDismisser,
        urlOpener: URLOpener,
        router: RouterProtocol,

        imageLoadingService: ImageLoadingServiceProtocol,

        instrumentSelectionListProvider: InstrumentSelectionListProviderProtocol,
        addressSearchService: APIServiceBase<AddressSearchRequest>,

        lessonPlanFetchingService: APIServiceBase<GetLessonPlansRequest>,
        lessonPlanRequestService: APIServiceBase<CreateLessonPlanRequest>,
        lessonPlanCancellationService: APIServiceBase<CancelLessonPlanRequest>,
        lessonPlanGetCheckoutService: APIServiceBase<GetLessonPlanCheckoutRequest>,
        lessonPlanCompleteCheckoutService: APIServiceBase<CompleteLessonPlanCheckoutRequest>,
        lessonPlanRepository: Repository<LessonPlan>,

        lessonSkippingService: APIServiceBase<SkipLessonRequest>,

        portfolioFetchingService: APIServiceBase<GetPortfolioRequest>,

        cardSetupCredentialFetchingService: APIServiceBase<GetCardSetupCredentialRequest>,
        cardSetupService: CardSetupServiceProtocol
    ) {
        self.state = state

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
        self.accessTokenProviderObserver = accessTokenProviderObserver

        self.analytics = AnalyticsCoordinator(service: analyticsService, accessTokenProviderObserver: accessTokenProviderObserver)
        self.analyticsService = analyticsService

        self.deviceTokenProvider = deviceTokenProvider
        self.deviceRegisterService = deviceRegisterService
        self.deviceTokenDeleter = deviceTokenDeleter

        self.pushNotificationAuthorizationCoordinator = pushNotificationAuthorizationCoordinator
        self.pushNotificationEventHandler = pushNotificationEventHandler

        self.calendarSyncStatusProvider = calendarSyncStatusProvider
        self.calendarInfoFetchingService = calendarInfoFetchingService

        self.uiAccessibility = uiAccessibility
        self.keyboardDismisser = keyboardDismisser
        self.urlOpener = urlOpener
        self.router = router

        self.imageLoadingService = imageLoadingService

        self.instrumentSelectionListProvider = instrumentSelectionListProvider
        self.addressSearchService = addressSearchService

        self.lessonPlanFetchingService = lessonPlanFetchingService
        self.lessonPlanRequestService = lessonPlanRequestService
        self.lessonPlanCancellationService = lessonPlanCancellationService
        self.lessonPlanGetCheckoutService = lessonPlanGetCheckoutService
        self.lessonPlanCompleteCheckoutService = lessonPlanCompleteCheckoutService
        self.lessonPlanRepository = lessonPlanRepository

        self.lessonSkippingService = lessonSkippingService

        self.portfolioFetchingService = portfolioFetchingService

        self.cardSetupCredentialFetchingService = cardSetupCredentialFetchingService
        self.cardSetupService = cardSetupService
    }
}
