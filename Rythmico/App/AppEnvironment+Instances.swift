import UIKit
import UserNotifications
import Firebase
import Stripe
import Then

extension AppEnvironment: Then {}

extension AppEnvironment {
    static let live = AppEnvironment(
        state: AppState(),

        remoteConfig: RemoteConfig(),

        date: Date.init,
        calendarType: { Calendar.current.identifier },
        locale: .autoupdatingCurrent,
        timeZone: .autoupdatingCurrent,

        eventEmitter: .default,

        settings: UserDefaults.standard,
        keychain: Keychain.localKeychain,

        appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
        appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
        appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifier(notificationCenter: .default),
        authenticationService: AuthenticationService(),
        deauthenticationService: DeauthenticationService(),
        accessTokenProviderObserver: AuthenticationAccessTokenProviderObserver(broadcast: AuthenticationAccessTokenProviderBroadcast()),

        deviceTokenProvider: Messaging.messaging(),
        deviceRegisterService: APIService(),
        deviceTokenDeleter: Messaging.messaging(),

        pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenter.current(),
            registerService: UIApplication.shared
        ),
        pushNotificationEventHandler: PushNotificationEventHandler(),

        uiAccessibility: UIAccessibility.self,
        keyboardDismisser: UIApplication.shared,
        urlOpener: UIApplication.shared,
        router: Router(),

        imageLoadingService: ImageLoadingService(),

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
    )

    func cardSetupCoordinator() -> CardSetupCoordinator {
        CardSetupCoordinator(service: cardSetupService)
    }
}

#if DEBUG
extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy.with {
            $0.setUpFake()

            $0.instrumentSelectionListProvider = InstrumentSelectionListProviderStub(instruments: Instrument.allCases)
            $0.addressSearchService = fakeAPIService(result: .success(.stub))

            $0.lessonPlanFetchingService = fakeAPIService(result: .success(.stub))
            $0.lessonPlanRequestService = fakeAPIService(result: .success(.davidGuitarPlanStub))
            $0.lessonPlanCancellationService = fakeAPIService(result: .success(.cancelledJackGuitarPlanStub))
            $0.lessonPlanGetCheckoutService = fakeAPIService(result: .success(.stub))
            $0.lessonPlanCompleteCheckoutService = fakeAPIService(result: .success(.scheduledJackGuitarPlanStub))

            $0.lessonSkippingService = fakeAPIService(result: .success(.scheduledSkippedJackGuitarPlanStub))

            $0.portfolioFetchingService = fakeAPIService(result: .success(.longStub))

            $0.cardSetupCredentialFetchingService = fakeAPIService(result: .success(.stub))
            $0.cardSetupService = CardSetupServiceStub(result: .success(STPSetupIntentFake()), delay: fakeAPIServicesDelay)
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
            accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverDummy(),

            deviceTokenProvider: DeviceTokenProviderDummy(),
            deviceRegisterService: APIServiceDummy(),
            deviceTokenDeleter: DeviceTokenDeleterDummy(),

            pushNotificationAuthorizationCoordinator: .dummy,
            pushNotificationEventHandler: PushNotificationEventHandlerDummy(),

            uiAccessibility: UIAccessibilityDummy.self,
            keyboardDismisser: KeyboardDismisserDummy(),
            urlOpener: URLOpenerDummy(),
            router: RouterDummy(),

            imageLoadingService: ImageLoadingServiceDummy(),

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
