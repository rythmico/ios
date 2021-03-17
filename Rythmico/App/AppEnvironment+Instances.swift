import UIKit
import UserNotifications
import EventKit
import Firebase
import Mixpanel
import Stripe
import Then

extension AppEnvironment: Then {}

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

        appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
        appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
        appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifier(notificationCenter: .default),
        authenticationService: AuthenticationService(),
        deauthenticationService: DeauthenticationService(),
        userCredentialProvider: UserCredentialProvider(emitter: UserCredentialEmitter()),

        analyticsService: Mixpanel.mainInstance(),

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
        uiAccessibility: UIAccessibility.self,
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

#if DEBUG
extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy.with {
            $0.setUpFake()

            $0.instrumentSelectionListProvider = InstrumentSelectionListProviderStub(instruments: Instrument.allCases)
            $0.fakeAPIEndpoint(for: \.addressSearchCoordinator, result: .success(.stub))

            $0.fakeAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success(.stub))
            $0.fakeAPIEndpoint(for: \.lessonPlanRequestCoordinator, result: .success(.davidGuitarPlanStub))
            $0.fakeAPIEndpoint(for: \.lessonPlanCancellationCoordinator, result: .success(.cancelledJackGuitarPlanStub))
            $0.fakeAPIEndpoint(for: \.lessonPlanGetCheckoutCoordinator, result: .success(.stub))
            $0.fakeAPIEndpoint(for: \.lessonPlanCompleteCheckoutCoordinator, result: .success(.scheduledJackGuitarPlanStub))

            $0.fakeAPIEndpoint(for: \.lessonSkippingCoordinator, result: .success(.scheduledSkippedJackGuitarPlanStub))

            $0.fakeAPIEndpoint(for: \.portfolioFetchingCoordinator, result: .success(.longStub))

            $0.fakeAPIEndpoint(for: \.cardSetupCredentialFetchingCoordinator, result: .success(.stub))
        }
    }
}

extension AppEnvironment {
    static var dummy: AppEnvironment {
        AppEnvironment(
            state: AppState(),

            remoteConfig: RemoteConfigDummy(),

            date: { .stub },
            calendarType: { .gregorian },
            locale: Locale(identifier: "en_GB"),
            timeZone: TimeZone(identifier: "Europe/London")!,

            eventEmitter: NotificationCenter(),

            settings: UserDefaultsDummy(),
            keychain: KeychainDummy(),

            appleAuthorizationService: AppleAuthorizationServiceDummy(),
            appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcherDummy(),
            appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifierDummy(),
            authenticationService: AuthenticationServiceDummy(),
            deauthenticationService: DeauthenticationServiceDummy(),
            userCredentialProvider: UserCredentialProviderDummy(),

            analyticsService: AnalyticsServiceDummy(),

            deviceTokenProvider: DeviceTokenProviderDummy(),
            deviceRegisterService: APIServiceDummy(),
            deviceTokenDeleter: DeviceTokenDeleterDummy(),

            pushNotificationAuthorizationCoordinator: .dummy,
            pushNotificationEventHandler: PushNotificationEventHandlerDummy(),

            calendarSyncStatusProvider: CalendarSyncStatusProviderDummy(),
            calendarInfoFetchingService: APIServiceDummy(),

            sceneState: { .active },
            uiAccessibility: UIAccessibilityDummy.self,
            keyboardDismisser: KeyboardDismisserDummy(),
            urlOpener: URLOpenerDummy(),
            router: RouterDummy(),

            imageLoadingService: ImageLoadingServiceDummy(),
            imageProcessingService: ImageProcessingServiceDummy(),

            instrumentSelectionListProvider: InstrumentSelectionListProviderDummy(),
            addressSearchService: APIServiceDummy(),

            lessonPlanFetchingService: APIServiceDummy(),
            lessonPlanRequestService: APIServiceDummy(),
            lessonPlanCancellationService: APIServiceDummy(),
            lessonPlanGetCheckoutService: APIServiceDummy(),
            lessonPlanCompleteCheckoutService: APIServiceDummy(),
            lessonPlanRepository: Repository(),

            lessonSkippingService: APIServiceDummy(),

            portfolioFetchingService: APIServiceDummy(),

            cardSetupCredentialFetchingService: APIServiceDummy(),
            cardSetupService: CardSetupServiceDummy()
        )
    }
}
#endif
