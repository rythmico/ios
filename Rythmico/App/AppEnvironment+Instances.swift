import UIKit
import UserNotifications
import Firebase
import Then

extension AppEnvironment: Then {}

extension AppEnvironment {
    static let live = AppEnvironment(
        locale: .autoupdatingCurrent,
        keychain: Keychain.localKeychain,
        appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
        appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
        appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifier(notificationCenter: NotificationCenter.default),
        authenticationService: AuthenticationService(),
        deauthenticationService: DeauthenticationService(),
        accessTokenProviderObserver: AuthenticationAccessTokenProviderObserver(broadcast: AuthenticationAccessTokenProviderBroadcast()),
        instrumentSelectionListProvider: InstrumentSelectionListProvider(),
        addressSearchService: APIService(),
        lessonPlanFetchingService: APIService(),
        lessonPlanRequestService: APIService(),
        lessonPlanCancellationService: APIService(),
        lessonPlanRepository: Repository(),
        deviceTokenProvider: InstanceID.instanceID(),
        deviceRegisterService: APIService(),
        deviceTokenDeleter: InstanceID.instanceID(),
        pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenter.current(),
            registerService: UIApplication.shared,
            queue: DispatchQueue.main
        ),
        keyboardDismisser: UIApplication.shared,
        uiAccessibility: UIAccessibility.self,
        urlOpener: UIApplication.shared
    )
}

extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy.with {
            $0.userAuthenticated()
            $0.appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
            $0.authenticationService = AuthenticationServiceStub(result: .success(fakeAccessTokenProvider), delay: 2)
            $0.deauthenticationService = DeauthenticationServiceStub()
            $0.instrumentSelectionListProvider = InstrumentSelectionListProviderStub(instruments: Instrument.allCases)
            $0.addressSearchService = APIServiceStub(result: .success(.stub), delay: 1)
            $0.lessonPlanFetchingService = APIServiceStub(result: .success(.stub), delay: 1.5)
            $0.lessonPlanRequestService = APIServiceStub(result: .success(.davidGuitarPlanStub), delay: 2)
            $0.lessonPlanCancellationService = APIServiceStub(result: .success(.cancelledJackGuitarPlanStub), delay: 2)
            $0.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
                center: UNUserNotificationCenterStub(
                    authorizationStatus: .notDetermined,
                    authorizationRequestResult: (true, nil)
                ),
                registerService: PushNotificationRegisterServiceDummy(),
                queue: nil
            )
            $0.keyboardDismisser = UIApplication.shared
        }
    }

    private static let fakeAccessTokenProvider = AuthenticationAccessTokenProviderStub(result: .success("ACCESS_TOKEN"))
}

extension AppEnvironment {
    static var dummy: AppEnvironment {
        AppEnvironment(
            locale: Locale(identifier: "en_GB"),
            keychain: KeychainDummy(),
            appleAuthorizationService: AppleAuthorizationServiceDummy(),
            appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcherDummy(),
            appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifierDummy(),
            authenticationService: AuthenticationServiceDummy(),
            deauthenticationService: DeauthenticationServiceDummy(),
            accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverDummy(),
            instrumentSelectionListProvider: InstrumentSelectionListProviderDummy(),
            addressSearchService: APIServiceDummy(),
            lessonPlanFetchingService: APIServiceDummy(),
            lessonPlanRequestService: APIServiceDummy(),
            lessonPlanCancellationService: APIServiceDummy(),
            lessonPlanRepository: Repository(),
            deviceTokenProvider: DeviceTokenProviderDummy(),
            deviceRegisterService: APIServiceDummy(),
            deviceTokenDeleter: DeviceTokenDeleterDummy(),
            pushNotificationAuthorizationCoordinator: .dummy,
            keyboardDismisser: KeyboardDismisserDummy(),
            uiAccessibility: UIAccessibilityDummy.self,
            urlOpener: URLOpenerDummy()
        )
    }
}

// Modifiers (debug-only)
extension AppEnvironment {
    mutating func userAuthenticated() {
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(currentProvider: Self.fakeAccessTokenProvider)
    }

    mutating func userUnauthenticated() {
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverDummy()
    }
}
