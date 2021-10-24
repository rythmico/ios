import SwiftUIEncore

extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy => {
            $0.setUpFake()

            $0.fakeAPIEndpoint(for: \.tutorStatusFetchingCoordinator, result: .success(.verified))

            $0.fakeAPIEndpoint(for: \.bookingsFetchingCoordinator, result: .success(.stub))

            $0.fakeAPIEndpoint(for: \.bookingRequestFetchingCoordinator, result: .success([.stub, .longStub]))
            $0.fakeAPIEndpoint(for: \.bookingRequestApplyingCoordinator, result: .success(.stub))

            $0.fakeAPIEndpoint(for: \.bookingApplicationFetchingCoordinator, result: .success([.longStub, .stubWithAbout] + .stub))
            $0.fakeAPIEndpoint(for: \.bookingApplicationRetractionCoordinator, result: .success(.stub))
        }
    }
}

extension AppEnvironment {
    static var dummy: AppEnvironment {
        AppEnvironment(
            tabSelection: TabSelection(),

            remoteConfig: RemoteConfigDummy(),

            appOrigin: .testFlight,

            date: { .stub },
            calendarType: { .gregorian },
            locale: .neutral,
            timeZone: .neutral,

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

            imageLoadingService: ImageLoadingServiceDummy(),
            imageProcessingService: ImageProcessingServiceDummy(),

            tutorStatusFetchingService: APIServiceDummy(),

            bookingsRepository: Repository(),
            bookingsFetchingService: APIServiceDummy(),

            bookingRequestRepository: Repository(),
            bookingRequestFetchingService: APIServiceDummy(),
            bookingRequestApplyingService: APIServiceDummy(),

            bookingApplicationRepository: Repository(),
            bookingApplicationFetchingService: APIServiceDummy(),
            bookingApplicationRetractionService: APIServiceDummy()
        )
    }
}
