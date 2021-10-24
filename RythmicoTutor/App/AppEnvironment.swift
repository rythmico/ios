import SwiftUIEncore
import ComposableNavigator
import UserNotifications
import EventKit
import Firebase

struct AppEnvironment {
    var tabSelection: TabSelection
    let bookingsTabNavigation = Navigator.Datasource(root: BookingsTabScreen())
    let bookingRequestsTabNavigation = Navigator.Datasource(root: BookingRequestsTabScreen())

    var remoteConfigCoordinator: RemoteConfigCoordinator
    var remoteConfig: RemoteConfigServiceProtocol

    var appOrigin: AppOriginClient

    var date: () -> Date
    var calendarType: () -> Calendar.Identifier
    var locale: Locale
    var timeZone: TimeZone

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

    var deviceRegisterCoordinator: DeviceRegisterCoordinator
    var deviceUnregisterCoordinator: DeviceUnregisterCoordinator

    var pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator
    var pushNotificationEventHandler: PushNotificationEventHandlerProtocol

    var calendarSyncCoordinator: CalendarSyncCoordinator

    var sceneState: () -> UIApplication.State
    var keyboardDismisser: KeyboardDismisser
    var urlOpener: URLOpener

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
        tabSelection: TabSelection,

        remoteConfig: RemoteConfigServiceProtocol,

        appOrigin: AppOriginClient,

        date: @escaping () -> Date,
        calendarType: @escaping () -> Calendar.Identifier,
        locale: Locale,
        timeZone: TimeZone,

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

        errorLogger: (UserCredentialProviderBase) -> ErrorLoggerProtocol,

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

        imageLoadingService: ImageLoadingServiceProtocol,
        imageProcessingService: ImageProcessingServiceProtocol,

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
        self.tabSelection = tabSelection

        let remoteConfigCoordinator = RemoteConfigCoordinator(service: remoteConfig)
        self.remoteConfigCoordinator = remoteConfigCoordinator
        self.remoteConfig = remoteConfig

        self.appOrigin = appOrigin

        self.date = date
        self.calendarType = calendarType
        self.locale = locale
        self.timeZone = timeZone

        self.eventEmitter = eventEmitter

        self.settings = settings
        self.keychain = keychain

        self.accessibilitySettings = accessibilitySettings
        self.voiceOver = voiceOver

        let userCredentialProvider = userCredentialProvider(keychain)
        self.errorLogger = errorLogger(userCredentialProvider)

        let apiActivityErrorHandler = APIActivityErrorHandler(
            userCredentialProvider: userCredentialProvider,
            remoteConfigCoordinator: remoteConfigCoordinator,
            settings: settings
        )
        self.apiActivityErrorHandler = apiActivityErrorHandler

        func coordinator<R: RythmicoAPIRequest>(for service: APIServiceBase<R>) -> APIActivityCoordinator<R> {
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

        self.imageLoadingCoordinator = {
            ImageLoadingCoordinator(
                loadingService: imageLoadingService,
                processingService: imageProcessingService
            )
        }

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

extension AppEnvironment {
    static let live = AppEnvironment.initLive { .init(
        tabSelection: TabSelection(),

        remoteConfig: RemoteConfig(),

        appOrigin: .live,

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

        siwaAuthorizationService: SIWAAuthorizationService(controllerType: SIWAAuthorizationController.self),
        siwaService: APIService(),
        userCredentialProvider: UserCredentialProvider.init,
        siwaCredentialStateProvider: SIWACredentialStateFetcher(),
        siwaCredentialRevocationNotifier: SIWACredentialRevocationNotifier(notificationCenter: .default),

        errorLogger: { ErrorLogger(crashlyticsLogger: .crashlytics(), userCredentialProvider: $0) },

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

        imageLoadingService: ImageLoadingService(),
        imageProcessingService: ImageProcessingService(),

        tutorStatusFetchingService: APIService(),

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
