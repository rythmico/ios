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
        addressSearchService: AddressSearchService(),
        lessonPlanFetchingService: LessonPlanFetchingService(),
        lessonPlanRequestService: LessonPlanRequestService(),
        lessonPlanCancellationService: LessonPlanCancellationService(),
        lessonPlanRepository: LessonPlanRepository(),
        deviceTokenProvider: InstanceID.instanceID(),
        deviceRegisterService: DeviceRegisterService(),
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
            $0.lessonPlanFetchingService = LessonPlanFetchingServiceStub(result: .success(.stub), delay: 1.5)
            $0.instrumentSelectionListProvider = InstrumentSelectionListProviderStub(instruments: Instrument.allCases)
            $0.addressSearchService = AddressSearchServiceStub(result: .success([.stub]), delay: 1)
            $0.lessonPlanRequestService = LessonPlanRequestServiceStub(result: .success(.davidGuitarPlanStub), delay: 2)
            $0.lessonPlanCancellationService = LessonPlanCancellationServiceStub(result: .success(.cancelledJackGuitarPlanStub), delay: 2)
            $0.pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
                center: UNUserNotificationCenterStub(
                    authorizationStatus: .notDetermined,
                    authorizationRequestResult: (true, nil)
                ),
                registerService: PushNotificationRegisterServiceDummy(),
                queue: nil
            )
        }
    }
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
            addressSearchService: AddressSearchServiceDummy(),
            lessonPlanFetchingService: LessonPlanFetchingServiceDummy(),
            lessonPlanRequestService: LessonPlanRequestServiceDummy(),
            lessonPlanCancellationService: LessonPlanCancellationServiceDummy(),
            lessonPlanRepository: LessonPlanRepository(),
            deviceTokenProvider: DeviceTokenProviderDummy(),
            deviceRegisterService: DeviceRegisterServiceDummy(),
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
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(
            currentProvider: AuthenticationAccessTokenProviderStub(
                result: .success("ACCESS_TOKEN")
            )
        )
    }
}
