import SwiftUIEncore
import ComposableNavigator
import UserNotifications
import EventKit

struct AppEnvironment {
    var tabSelection: TabSelection
    let bookingsTabNavigation = Navigator.Datasource(root: BookingsTabScreen())
    let bookingRequestsTabNavigation = Navigator.Datasource(root: BookingRequestsTabScreen())

    var appStatus: AppStatusProvider
    var appOrigin: AppOriginClient

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
    var apiEventHandler: APIEventHandlerProtocol

    var calendarSyncCoordinator: CalendarSyncCoordinator

    var sceneState: () -> UIApplication.State
    var keyboardDismisser: KeyboardDismisser
    var urlOpener: URLOpener

    var imageLoadingCoordinator: () -> ImageLoadingCoordinator

    var tutorProfileStatusFetchingCoordinator: APIActivityCoordinator<GetTutorProfileStatusRequest>

    var bookingsRepository: Repository<Booking>
    var bookingsFetchingCoordinator: APIActivityCoordinator<BookingsGetRequest>

    var bookingRequestRepository: Repository<BookingRequest>
    var bookingRequestFetchingCoordinator: APIActivityCoordinator<BookingRequestsGetRequest>
    var bookingRequestApplyingCoordinator: () -> APIActivityCoordinator<BookingRequestApplyRequest>

    var bookingApplicationRepository: Repository<BookingApplication>
    var bookingApplicationFetchingCoordinator: APIActivityCoordinator<BookingApplicationsGetRequest>
    var bookingApplicationRetractionCoordinator: () -> APIActivityCoordinator<BookingApplicationsRetractRequest>

    init(
        tabSelection: TabSelection,

        appStatus: AppStatusProvider,
        appOrigin: AppOriginClient,

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
        apiEventHandler: APIEventHandlerProtocol,

        calendarSyncStatusProvider: CalendarSyncStatusProviderBase,
        calendarInfoFetchingService: APIServiceBase<GetCalendarInfoRequest>,

        sceneState: @escaping () -> UIApplication.State,
        keyboardDismisser: KeyboardDismisser,
        urlOpener: URLOpener,

        imageLoadingService: ImageLoadingServiceProtocol,
        imageProcessingService: ImageProcessingServiceProtocol,

        tutorProfileStatusFetchingService: APIServiceBase<GetTutorProfileStatusRequest>,

        bookingsRepository: Repository<Booking>,
        bookingsFetchingService: APIServiceBase<BookingsGetRequest>,

        bookingRequestRepository: Repository<BookingRequest>,
        bookingRequestFetchingService: APIServiceBase<BookingRequestsGetRequest>,
        bookingRequestApplyingService: APIServiceBase<BookingRequestApplyRequest>,

        bookingApplicationRepository: Repository<BookingApplication>,
        bookingApplicationFetchingService: APIServiceBase<BookingApplicationsGetRequest>,
        bookingApplicationRetractionService: APIServiceBase<BookingApplicationsRetractRequest>
    ) {
        self.tabSelection = tabSelection

        self.appStatus = appStatus
        self.appOrigin = appOrigin

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
            userCredentialProvider: userCredentialProvider,
            settings: settings
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
        self.apiEventHandler = apiEventHandler
        
        self.calendarSyncCoordinator = CalendarSyncCoordinator(
            calendarSyncStatusProvider: calendarSyncStatusProvider,
            calendarInfoFetchingCoordinator: coordinator(for: calendarInfoFetchingService),
            eventEmitter: eventEmitter,
            urlOpener: urlOpener
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

        self.tutorProfileStatusFetchingCoordinator = coordinator(for: tutorProfileStatusFetchingService)

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

extension AppEnvironment {
    static let live = AppEnvironment.initLive { .init(
        tabSelection: TabSelection(),
        
        appStatus: .init(),
        appOrigin: .live,

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

        errorLogger: { ErrorLogger(userCredentialProvider: $0) },

        apnsRegistrationService: UIApplication.shared,
        registerAPNSTokenService: APIService(),
        pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenter.current()
        ),
        apiEventHandler: APIEventHandler(),

        calendarSyncStatusProvider: CalendarSyncStatusProvider(accessProvider: EKEventStore()),
        calendarInfoFetchingService: APIService(),

        sceneState: { UIApplication.shared.applicationState },
        keyboardDismisser: UIApplication.shared,
        urlOpener: UIApplication.shared,

        imageLoadingService: ImageLoadingService(),
        imageProcessingService: ImageProcessingService(),

        tutorProfileStatusFetchingService: APIService(),

        bookingsRepository: Repository(),
        bookingsFetchingService: APIService(),

        bookingRequestRepository: Repository(),
        bookingRequestFetchingService: APIService(),
        bookingRequestApplyingService: APIService(),

        bookingApplicationRepository: Repository(),
        bookingApplicationFetchingService: APIService(),
        bookingApplicationRetractionService: APIService()
    )}
}
