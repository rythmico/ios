import UIKit
import UserNotifications
import EventKit
import Firebase
import Mixpanel
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

    var apiErrorHandler: APIActivityErrorHandlerProtocol {
        APIActivityErrorHandler(remoteConfigCoordinator: remoteConfigCoordinator, settings: settings)
    }
}

#if DEBUG
extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy.with {
            $0.setUpFake()

            $0.fakeAPIEndpoint(for: \.tutorStatusFetchingCoordinator, result: .success(.registrationPendingStub))

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
#endif
