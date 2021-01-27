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

    var deviceTokenProvider: DeviceTokenProvider
    var deviceRegisterService: APIServiceBase<AddDeviceRequest>
    var deviceTokenDeleter: DeviceTokenDeleter

    var pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator
    var pushNotificationEventHandler: PushNotificationEventHandlerProtocol

    var calendarAccessProvider: CalendarAccessProviderProtocol
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
}
