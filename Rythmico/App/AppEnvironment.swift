import ComposableNavigator
import EventKit
import Stripe
import StudentDO
import SwiftUIEncore
import UserNotifications

struct AppEnvironment {
    var tabSelection: TabSelection
    let lessonsTabNavigation = Navigator.Datasource(root: LessonsScreen())
    let profileTabNavigation = Navigator.Datasource(root: ProfileScreen())

    var appStatus: AppStatusProvider
    var appOrigin: AppOriginClient

    var uuid: () -> UUID
    var date: () -> Date
    var dateOnly: () -> DateOnly
    var timeOnly: () -> TimeOnly
    var calendarType: () -> Calendar.Identifier
    var locale: () -> Locale
    var timeZone: () -> TimeZone

    var eventEmitter: NotificationCenter

    var settings: UserDefaults
    var keychain: KeychainProtocol

    var accessibilitySettings: AccessibilitySettings
    var voiceOver: VoiceOverServiceProtocol.Type

    var siwaAuthorizationService: SIWAAuthorizationServiceProtocol
    var siwaCoordinator: () -> APIActivityCoordinator<SIWARequest>
    var userCredentialProvider: UserCredentialProviderBase
    var siwaCredentialStateProvider: SIWACredentialStateProvider
    var siwaCredentialRevocationNotifier: SIWACredentialRevocationNotifying

    var errorLogger: ErrorLoggerProtocol

    var apiActivityErrorHandler: APIActivityErrorHandlerProtocol

    var apnsRegistrationService: APNSRegistrationServiceProtocol
    var registerAPNSTokenCoordinator: APIActivityCoordinator<RegisterAPNSTokenRequest>
    var pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator
    var apiEventListener: APIEventListenerBase<StudentDTO.KnownAPIEvent>

    var calendarSyncCoordinator: CalendarSyncCoordinator

    var analytics: AnalyticsCoordinator

    var sceneState: () -> UIApplication.State
    var keyboardDismisser: KeyboardDismisser
    var urlOpener: URLOpener

    var imageLoadingCoordinator: () -> ImageLoadingCoordinator

    var availableInstrumentsFetchingCoordinator: () -> APIActivityCoordinator<GetAvailableInstrumentsRequest>
    var addressSearchCoordinator: () -> APIActivityCoordinator<AddressSearchRequest>

    var lessonPlanRequestFetchingCoordinator: APIActivityCoordinator<GetLessonPlanRequestsRequest>
    var lessonPlanRequestCreationCoordinator: () -> APIActivityCoordinator<CreateLessonPlanRequestRequest>
    var lessonPlanRequestRepository: Repository<LessonPlanRequest>

    var lessonPlanFetchingCoordinator: APIActivityCoordinator<GetLessonPlansRequest>
    var lessonPlanPausingCoordinator: () -> APIActivityCoordinator<PauseLessonPlanRequest>
    var lessonPlanResumingCoordinator: () -> APIActivityCoordinator<ResumeLessonPlanRequest>
    var lessonPlanCancellationCoordinator: () -> APIActivityCoordinator<CancelLessonPlanRequest>
    var lessonPlanGetCheckoutCoordinator: () -> APIActivityCoordinator<GetLessonPlanCheckoutRequest>
    var lessonPlanCompleteCheckoutCoordinator: () -> APIActivityCoordinator<CompleteLessonPlanCheckoutRequest>
    var lessonPlanRepository: Repository<LessonPlan>

    var appStoreReviewPrompt: AppStoreReviewPrompt

    var lessonSkippingCoordinator: () -> APIActivityCoordinator<SkipLessonRequest>

    var portfolioFetchingCoordinator: () -> APIActivityCoordinator<GetPortfolioRequest>

    var cardSetupCredentialFetchingCoordinator: () -> APIActivityCoordinator<GetCardSetupCredentialRequest>
    var cardSetupCoordinator: () -> CardSetupCoordinator

    var customerPortalURLFetchingCoordinator: () -> APIActivityCoordinator<GetCustomerPortalURLRequest>

    init(
        tabSelection: TabSelection,

        appStatus: AppStatusProvider,
        appOrigin: AppOriginClient,

        uuid: @escaping () -> UUID,
        date: @escaping () -> Date,
        calendarType: @escaping () -> Calendar.Identifier,
        locale: @escaping () -> Locale,
        timeZone: @escaping () -> TimeZone,

        eventEmitter: NotificationCenter,

        settings: UserDefaults,
        keychain: KeychainProtocol,

        accessibilitySettings: AccessibilitySettings,
        voiceOver: VoiceOverServiceProtocol.Type,

        siwaAuthorizationService: SIWAAuthorizationServiceProtocol,
        siwaService: APIServiceBase<SIWARequest>,
        userCredentialProvider: (KeychainProtocol) -> UserCredentialProviderBase,
        siwaCredentialStateProvider: SIWACredentialStateProvider,
        siwaCredentialRevocationNotifier: SIWACredentialRevocationNotifying,

        errorLogger: ErrorLoggerProtocol,

        apnsRegistrationService: APNSRegistrationServiceProtocol,
        registerAPNSTokenService: APIServiceBase<RegisterAPNSTokenRequest>,
        pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator,
        apiEventListener: (UserCredentialProviderBase) -> APIEventListenerBase<StudentDTO.KnownAPIEvent>,

        calendarSyncStatusProvider: CalendarSyncStatusProviderBase,
        calendarInfoFetchingService: APIServiceBase<GetCalendarInfoRequest>,

        analyticsService: AnalyticsServiceProtocol,

        sceneState: @escaping () -> UIApplication.State,
        keyboardDismisser: KeyboardDismisser,
        urlOpener: URLOpener,

        imageLoadingService: ImageLoadingServiceProtocol,
        imageProcessingService: ImageProcessingServiceProtocol,

        availableInstrumentsFetchingService: APIServiceBase<GetAvailableInstrumentsRequest>,
        addressSearchService: APIServiceBase<AddressSearchRequest>,

        lessonPlanRequestFetchingService: APIServiceBase<GetLessonPlanRequestsRequest>,
        lessonPlanRequestCreationService: APIServiceBase<CreateLessonPlanRequestRequest>,
        lessonPlanRequestRepository: Repository<LessonPlanRequest>,

        lessonPlanFetchingService: APIServiceBase<GetLessonPlansRequest>,
        lessonPlanPausingService: APIServiceBase<PauseLessonPlanRequest>,
        lessonPlanResumingService: APIServiceBase<ResumeLessonPlanRequest>,
        lessonPlanCancellationService: APIServiceBase<CancelLessonPlanRequest>,
        lessonPlanGetCheckoutService: APIServiceBase<GetLessonPlanCheckoutRequest>,
        lessonPlanCompleteCheckoutService: APIServiceBase<CompleteLessonPlanCheckoutRequest>,
        lessonPlanRepository: Repository<LessonPlan>,

        appStoreReviewPrompt: AppStoreReviewPrompt,

        lessonSkippingService: APIServiceBase<SkipLessonRequest>,

        portfolioFetchingService: APIServiceBase<GetPortfolioRequest>,

        cardSetupCredentialFetchingService: APIServiceBase<GetCardSetupCredentialRequest>,
        cardSetupService: CardSetupServiceProtocol,

        customerPortalURLFetchingService: APIServiceBase<GetCustomerPortalURLRequest>
    ) {
        self.tabSelection = tabSelection

        self.appStatus = appStatus
        self.appOrigin = appOrigin

        self.uuid = uuid
        self.date = date
        self.dateOnly = { .init(date(), in: timeZone()) }
        self.timeOnly = { .init(date(), in: timeZone()) }
        self.calendarType = calendarType
        self.locale = locale
        self.timeZone = timeZone

        self.eventEmitter = eventEmitter

        self.settings = settings
        self.keychain = keychain

        self.accessibilitySettings = accessibilitySettings
        self.voiceOver = voiceOver

        let userCredentialProvider = userCredentialProvider(keychain)
        self.errorLogger = errorLogger

        let apiActivityErrorHandler = APIActivityErrorHandler(
            appStatusProvider: appStatus,
            userCredentialProvider: userCredentialProvider
        )
        self.apiActivityErrorHandler = apiActivityErrorHandler

        func coordinator<R: APIRequest>(for service: APIServiceBase<R>) -> APIActivityCoordinator<R> {
            APIActivityCoordinator(
                userCredentialProvider: userCredentialProvider,
                errorHandler: apiActivityErrorHandler,
                service: service
            )
        }

        self.siwaAuthorizationService = siwaAuthorizationService
        self.siwaCredentialStateProvider = siwaCredentialStateProvider
        self.siwaCredentialRevocationNotifier = siwaCredentialRevocationNotifier
        self.siwaCoordinator = { coordinator(for: siwaService) }
        self.userCredentialProvider = userCredentialProvider

        self.apnsRegistrationService = apnsRegistrationService
        self.registerAPNSTokenCoordinator = coordinator(for: registerAPNSTokenService)
        self.pushNotificationAuthorizationCoordinator = pushNotificationAuthorizationCoordinator
        self.apiEventListener = apiEventListener(userCredentialProvider)

        let calendarSyncCoordinator = CalendarSyncCoordinator(
            calendarSyncStatusProvider: calendarSyncStatusProvider,
            calendarInfoFetchingCoordinator: coordinator(for: calendarInfoFetchingService),
            eventEmitter: eventEmitter,
            urlOpener: urlOpener
        )
        self.calendarSyncCoordinator = calendarSyncCoordinator

        self.analytics = AnalyticsCoordinator(
            service: analyticsService,
            userCredentialProvider: userCredentialProvider,
            accessibilitySettings: accessibilitySettings,
            notificationAuthCoordinator: pushNotificationAuthorizationCoordinator,
            calendarSyncCoordinator: calendarSyncCoordinator
        )

        self.sceneState = sceneState
        self.keyboardDismisser = keyboardDismisser
        self.urlOpener = urlOpener

        self.imageLoadingCoordinator = {
            ImageLoadingCoordinator(
                loadingService: imageLoadingService,
                processingService: imageProcessingService
            )
        }

        self.availableInstrumentsFetchingCoordinator = { coordinator(for: availableInstrumentsFetchingService) }
        self.addressSearchCoordinator = { coordinator(for: addressSearchService) }

        self.lessonPlanRequestFetchingCoordinator = coordinator(for: lessonPlanRequestFetchingService)
        self.lessonPlanRequestCreationCoordinator = { coordinator(for: lessonPlanRequestCreationService) }
        self.lessonPlanRequestRepository = lessonPlanRequestRepository

        self.lessonPlanFetchingCoordinator = coordinator(for: lessonPlanFetchingService)
        self.lessonPlanPausingCoordinator = { coordinator(for: lessonPlanPausingService) }
        self.lessonPlanResumingCoordinator = { coordinator(for: lessonPlanResumingService) }
        self.lessonPlanCancellationCoordinator = { coordinator(for: lessonPlanCancellationService) }
        self.lessonPlanGetCheckoutCoordinator = { coordinator(for: lessonPlanGetCheckoutService) }
        self.lessonPlanCompleteCheckoutCoordinator = { coordinator(for: lessonPlanCompleteCheckoutService) }
        self.lessonPlanRepository = lessonPlanRepository

        self.appStoreReviewPrompt = appStoreReviewPrompt

        self.lessonSkippingCoordinator = { coordinator(for: lessonSkippingService) }

        self.portfolioFetchingCoordinator = { coordinator(for: portfolioFetchingService) }

        self.cardSetupCredentialFetchingCoordinator = { coordinator(for: cardSetupCredentialFetchingService) }
        self.cardSetupCoordinator = { CardSetupCoordinator(service: cardSetupService) }

        self.customerPortalURLFetchingCoordinator = { coordinator(for: customerPortalURLFetchingService) }
    }
}

extension AppEnvironment {
    static let live = AppEnvironment.initLive { .init(
        tabSelection: TabSelection(),

        appStatus: .init(),
        appOrigin: .init(get: { .appStore }), // TODO: swap back to `live`

        uuid: UUID.init,
        date: Date.init,
        calendarType: { Calendar.current.identifier },
        locale: { .autoupdatingCurrent },
        timeZone: { .autoupdatingCurrent },

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

        siwaAuthorizationService: SIWAAuthorizationService(controllerType: SIWAAuthorizationController.self),
        siwaService: APIService(),
        userCredentialProvider: UserCredentialProvider.init,
        siwaCredentialStateProvider: SIWACredentialStateFetcher(),
        siwaCredentialRevocationNotifier: SIWACredentialRevocationNotifier(notificationCenter: .default),

        errorLogger: ErrorLogger(),

        apnsRegistrationService: UIApplication.shared,
        registerAPNSTokenService: APIService(),
        pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenter.current()
        ),
        apiEventListener: APIEventListener.init,

        calendarSyncStatusProvider: CalendarSyncStatusProvider(accessProvider: EKEventStore()),
        calendarInfoFetchingService: APIService(),

        analyticsService: AnalyticsService(),

        sceneState: { UIApplication.shared.applicationState },
        keyboardDismisser: UIApplication.shared,
        urlOpener: UIApplication.shared,

        imageLoadingService: ImageLoadingService(),
        imageProcessingService: ImageProcessingService(),

        availableInstrumentsFetchingService: APIService(),
        addressSearchService: APIService(),

        lessonPlanRequestFetchingService: APIService(),
        lessonPlanRequestCreationService: APIService(),
        lessonPlanRequestRepository: Repository(),

        lessonPlanFetchingService: APIService(),
        lessonPlanPausingService: APIService(),
        lessonPlanResumingService: APIService(),
        lessonPlanCancellationService: APIService(),
        lessonPlanGetCheckoutService: APIService(),
        lessonPlanCompleteCheckoutService: APIService(),
        lessonPlanRepository: Repository(),

        appStoreReviewPrompt: .live,

        lessonSkippingService: APIService(),

        portfolioFetchingService: APIService(),

        cardSetupCredentialFetchingService: APIService(),
        cardSetupService: STPPaymentHandler.shared(),

        customerPortalURLFetchingService: APIService()
    )}
}
