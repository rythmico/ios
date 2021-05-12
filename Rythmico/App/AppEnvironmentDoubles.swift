import UIKit
import Then

extension AppEnvironment: Then {}

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
            tabSelection: TabSelection(),

            remoteConfig: RemoteConfigDummy(),

            date: { .stub },
            calendarType: { .gregorian },
            locale: Locale(identifier: "en_GB"),
            timeZone: TimeZone(identifier: "Europe/London")!,

            eventEmitter: NotificationCenter(),

            settings: UserDefaultsDummy(),
            keychain: KeychainDummy(),

            accessibilitySettings: .dummy,
            voiceOver: VoiceOverServiceDummy.self,

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
