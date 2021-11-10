import SwiftUIEncore

extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy => {
            $0.setUpFake()

            $0.fakeAPIEndpoint(for: \.availableInstrumentsFetchingCoordinator, result: .success(.stub))
            $0.fakeAPIEndpoint(for: \.addressSearchCoordinator, result: .success(.stub))

            $0.fakeAPIEndpoint(for: \.lessonPlanFetchingCoordinator, result: .success(.stub))
            $0.fakeAPIEndpoint(for: \.lessonPlanRequestCreationCoordinator, result: .success(.stub))
            $0.fakeAPIEndpoint(for: \.lessonPlanPausingCoordinator, result: .success(.pausedJackGuitarPlanStub))
            $0.fakeAPIEndpoint(for: \.lessonPlanResumingCoordinator, result: .success(.activeJackGuitarPlanStub))
            $0.fakeAPIEndpoint(for: \.lessonPlanCancellationCoordinator, result: .success(.cancelledJackGuitarPlanStub))
            $0.fakeAPIEndpoint(for: \.lessonPlanGetCheckoutCoordinator, result: .success(.stub))
            $0.fakeAPIEndpoint(for: \.lessonPlanCompleteCheckoutCoordinator, result: .success(.activeJackGuitarPlanStub))

            $0.fakeAPIEndpoint(for: \.lessonSkippingCoordinator, result: .success(.activeSkippedJackGuitarPlanStub))

            $0.fakeAPIEndpoint(for: \.portfolioFetchingCoordinator, result: .success(.longStub))

            $0.fakeAPIEndpoint(for: \.cardSetupCredentialFetchingCoordinator, result: .success(.stub))

            $0.fakeAPIEndpoint(for: \.customerPortalURLFetchingCoordinator, result: .success(.stub))
        }
    }
}

extension AppEnvironment {
    static var dummy: AppEnvironment {
        AppEnvironment(
            tabSelection: TabSelection(),

            appStatus: .init(),
            appOrigin: .testFlight,

            uuid: { .zero },
            date: { .stub },
            calendarType: { .gregorian },
            locale: { .neutral },
            timeZone: { .neutral },

            eventEmitter: NotificationCenter(),

            settings: .noop,
            keychain: KeychainDummy(),

            accessibilitySettings: .dummy,
            voiceOver: VoiceOverServiceDummy.self,

            siwaAuthorizationService: SIWAAuthorizationServiceDummy(),
            siwaService: APIServiceDummy(),
            userCredentialProvider: { _ in UserCredentialProviderDummy() },
            siwaCredentialStateProvider: SIWACredentialStateFetcherDummy(),
            siwaCredentialRevocationNotifier: SIWACredentialRevocationNotifierDummy(),

            errorLogger: { _ in ErrorLoggerDummy() },

            apnsRegistrationService: APNSRegistrationServiceDummy(),
            registerAPNSTokenService: APIServiceDummy(),
            pushNotificationAuthorizationCoordinator: .dummy,
            apiEventHandler: APIEventHandlerDummy(),

            calendarSyncStatusProvider: CalendarSyncStatusProviderDummy(),
            calendarInfoFetchingService: APIServiceDummy(),

            analyticsService: AnalyticsServiceDummy(),

            sceneState: { .active },
            keyboardDismisser: KeyboardDismisserDummy(),
            urlOpener: URLOpenerDummy(),

            imageLoadingService: ImageLoadingServiceDummy(),
            imageProcessingService: ImageProcessingServiceDummy(),

            availableInstrumentsFetchingService: APIServiceDummy(),
            addressSearchService: APIServiceDummy(),

            lessonPlanRequestFetchingService: APIServiceDummy(),
            lessonPlanRequestCreationService: APIServiceDummy(),
            lessonPlanRequestRepository: Repository(),

            lessonPlanFetchingService: APIServiceDummy(),
            lessonPlanPausingService: APIServiceDummy(),
            lessonPlanResumingService: APIServiceDummy(),
            lessonPlanCancellationService: APIServiceDummy(),
            lessonPlanGetCheckoutService: APIServiceDummy(),
            lessonPlanCompleteCheckoutService: APIServiceDummy(),
            lessonPlanRepository: Repository(),

            appStoreReviewPrompt: .dummy,

            lessonSkippingService: APIServiceDummy(),

            portfolioFetchingService: APIServiceDummy(),

            cardSetupCredentialFetchingService: APIServiceDummy(),
            cardSetupService: CardSetupServiceDummy(),

            customerPortalURLFetchingService: APIServiceDummy()
        )
    }
}
