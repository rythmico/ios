import TutorDO
import SwiftUIEncore

extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy => {
            $0.setUpFake()

            $0.fakeAPIEndpoint(for: \.tutorProfileStatusFetchingCoordinator, result: .success(.verified))

            $0.fakeAPIEndpoint(for: \.bookingsFetchingCoordinator, result: .success(.stub))

            $0.fakeAPIEndpoint(for: \.lessonPlanRequestFetchingCoordinator, result: .success([.stub, .longStub]))

            $0.fakeAPIEndpoint(for: \.lessonPlanApplicationFetchingCoordinator, result: .success([.longStub, .stubWithAbout] + .stub))
            $0.fakeAPIEndpoint(for: \.lessonPlanApplicationCreationCoordinator, result: .success(.stub))
            $0.fakeAPIEndpoint(for: \.lessonPlanApplicationRetractionCoordinator, result: .success(.stub))
        }
    }
}

extension AppEnvironment {
    static var dummy: AppEnvironment {
        AppEnvironment(
            tabSelection: TabSelection(),

            appStatus: .init(),
            appOrigin: .testFlight,

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

            errorLogger: ErrorLoggerDummy(),

            apnsRegistrationService: APNSRegistrationServiceDummy(),
            registerAPNSTokenService: APIServiceDummy(),
            pushNotificationAuthorizationCoordinator: .dummy,
            apiEventListener: { _ in APIEventListenerDummy() },

            calendarSyncStatusProvider: CalendarSyncStatusProviderDummy(),
            calendarInfoFetchingService: APIServiceDummy(),

            sceneState: { .active },
            keyboardDismisser: KeyboardDismisserDummy(),
            urlOpener: URLOpenerDummy(),

            imageLoadingService: ImageLoadingServiceDummy(),
            imageProcessingService: ImageProcessingServiceDummy(),

            tutorProfileStatusFetchingService: APIServiceDummy(),

            bookingsRepository: Repository(),
            bookingsFetchingService: APIServiceDummy(),

            lessonPlanRequestRepository: Repository(),
            lessonPlanRequestFetchingService: APIServiceDummy(),

            lessonPlanApplicationRepository: Repository(),
            lessonPlanApplicationCreationService: APIServiceDummy(),
            lessonPlanApplicationFetchingService: APIServiceDummy(),
            lessonPlanApplicationRetractionService: APIServiceDummy()
        )
    }
}
