import UIKit
import UserNotifications
import EventKit
import Firebase
import Stripe

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

    var accessibilitySettings: AccessibilitySettings
    var voiceOver: VoiceOverServiceProtocol.Type

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
    var keyboardDismisser: KeyboardDismisser
    var urlOpener: URLOpener
    var router: RouterProtocol

    var imageLoadingCoordinator: () -> ImageLoadingCoordinator

    var instrumentSelectionListProvider: InstrumentSelectionListProviderProtocol
    var addressSearchCoordinator: () -> APIActivityCoordinator<AddressSearchRequest>

    var lessonPlanFetchingCoordinator: APIActivityCoordinator<GetLessonPlansRequest>
    var lessonPlanRequestCoordinator: () -> APIActivityCoordinator<CreateLessonPlanRequest>
    var lessonPlanCancellationCoordinator: () -> APIActivityCoordinator<CancelLessonPlanRequest>
    var lessonPlanGetCheckoutCoordinator: () -> APIActivityCoordinator<GetLessonPlanCheckoutRequest>
    var lessonPlanCompleteCheckoutCoordinator: () -> APIActivityCoordinator<CompleteLessonPlanCheckoutRequest>
    var lessonPlanRepository: Repository<LessonPlan>

    var lessonSkippingCoordinator: () -> APIActivityCoordinator<SkipLessonRequest>

    var portfolioFetchingCoordinator: () -> APIActivityCoordinator<GetPortfolioRequest>

    var cardSetupCredentialFetchingCoordinator: () -> APIActivityCoordinator<GetCardSetupCredentialRequest>
    var cardSetupCoordinator: () -> CardSetupCoordinator

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

        accessibilitySettings: AccessibilitySettings,
        voiceOver: VoiceOverServiceProtocol.Type,

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
        keyboardDismisser: KeyboardDismisser,
        urlOpener: URLOpener,
        router: RouterProtocol,

        imageLoadingService: ImageLoadingServiceProtocol,
        imageProcessingService: ImageProcessingServiceProtocol,

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

        self.accessibilitySettings = accessibilitySettings
        self.voiceOver = voiceOver

        self.appleAuthorizationService = appleAuthorizationService
        self.appleAuthorizationCredentialStateProvider = appleAuthorizationCredentialStateProvider
        self.appleAuthorizationCredentialRevocationNotifier = appleAuthorizationCredentialRevocationNotifier
        self.authenticationService = authenticationService
        self.deauthenticationService = deauthenticationService
        self.userCredentialProvider = userCredentialProvider

        self.analytics = AnalyticsCoordinator(
            service: analyticsService,
            userCredentialProvider: userCredentialProvider,
            accessibilitySettings: accessibilitySettings,
            notificationAuthCoordinator: pushNotificationAuthorizationCoordinator
        )
        self.analyticsService = analyticsService

        let apiActivityErrorHandler = APIActivityErrorHandler(remoteConfigCoordinator: remoteConfigCoordinator)
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
        self.keyboardDismisser = keyboardDismisser
        self.urlOpener = urlOpener
        self.router = router

        self.imageLoadingCoordinator = {
            ImageLoadingCoordinator(
                loadingService: imageLoadingService,
                processingService: imageProcessingService
            )
        }

        self.instrumentSelectionListProvider = instrumentSelectionListProvider
        self.addressSearchCoordinator = { coordinator(for: addressSearchService) }

        self.lessonPlanFetchingCoordinator = coordinator(for: lessonPlanFetchingService)
        self.lessonPlanRequestCoordinator = { coordinator(for: lessonPlanRequestService) }
        self.lessonPlanCancellationCoordinator = { coordinator(for: lessonPlanCancellationService) }
        self.lessonPlanGetCheckoutCoordinator = { coordinator(for: lessonPlanGetCheckoutService) }
        self.lessonPlanCompleteCheckoutCoordinator = { coordinator(for: lessonPlanCompleteCheckoutService) }
        self.lessonPlanRepository = lessonPlanRepository

        self.lessonSkippingCoordinator = { coordinator(for: lessonSkippingService) }

        self.portfolioFetchingCoordinator = { coordinator(for: portfolioFetchingService) }

        self.cardSetupCredentialFetchingCoordinator = { coordinator(for: cardSetupCredentialFetchingService) }
        self.cardSetupCoordinator = { CardSetupCoordinator(service: cardSetupService) }
    }
}

extension AppEnvironment {
    static let live = AppEnvironment.initLive { .init(
        state: AppState(),

        remoteConfig: RemoteConfig(),

        date: Date.init,
        calendarType: { Calendar.current.identifier },
        locale: .autoupdatingCurrent,
        timeZone: .autoupdatingCurrent,

        eventEmitter: .default,

        settings: .standard,
        keychain: Keychain.localKeychain,

        accessibilitySettings: AccessibilitySettings(
            isVoiceOverOn: UIAccessibility.isVoiceOverRunning,
            interfaceStyle: UITraitCollection.current.userInterfaceStyle,
            dynamicTypeSize: UITraitCollection.current.preferredContentSizeCategory,
            isBoldTextOn: UIAccessibility.isBoldTextEnabled
        ),
        voiceOver: UIAccessibility.self,

        appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
        appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
        appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifier(notificationCenter: .default),
        authenticationService: AuthenticationService(),
        deauthenticationService: DeauthenticationService(),
        userCredentialProvider: UserCredentialProvider(emitter: UserCredentialEmitter()),

        analyticsService: AnalyticsService(),

        deviceTokenProvider: Messaging.messaging(),
        deviceRegisterService: APIService(),
        deviceTokenDeleter: Messaging.messaging(),

        pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenter.current(),
            registerService: UIApplication.shared
        ),
        pushNotificationEventHandler: PushNotificationEventHandler(),

        calendarSyncStatusProvider: CalendarSyncStatusProvider(accessProvider: EKEventStore()),
        calendarInfoFetchingService: APIService(),

        sceneState: { UIApplication.shared.applicationState },
        keyboardDismisser: UIApplication.shared,
        urlOpener: UIApplication.shared,
        router: Router(),

        imageLoadingService: ImageLoadingService(),
        imageProcessingService: ImageProcessingService(),

        instrumentSelectionListProvider: InstrumentSelectionListProvider(),
        addressSearchService: APIService(),

        lessonPlanFetchingService: APIService(),
        lessonPlanRequestService: APIService(),
        lessonPlanCancellationService: APIService(),
        lessonPlanGetCheckoutService: APIService(),
        lessonPlanCompleteCheckoutService: APIService(),
        lessonPlanRepository: Repository(),

        lessonSkippingService: APIService(),

        portfolioFetchingService: APIService(),

        cardSetupCredentialFetchingService: APIService(),
        cardSetupService: STPPaymentHandler.shared()
    )}
}
