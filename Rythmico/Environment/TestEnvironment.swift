import Foundation
import Then
import class UIKit.UIApplication
import class UserNotifications.UNUserNotificationCenter
import class FirebaseInstanceID.InstanceID

extension AppEnvironment: Then {}

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

extension AppEnvironment {
    mutating func userAuthenticated() {
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(
            currentProvider: AuthenticationAccessTokenProviderStub(
                result: .success("ACCESS_TOKEN")
            )
        )
    }
}
