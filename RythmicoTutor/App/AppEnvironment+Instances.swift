import UIKit
import Firebase
import Then

extension AppEnvironment: Then {}

extension AppEnvironment {
    static let live = AppEnvironment(
        date: { Date() },
        calendar: .autoupdatingCurrent,
        locale: .autoupdatingCurrent,
        timeZone: .autoupdatingCurrent,

        keychain: Keychain.localKeychain,
        appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
        appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
        appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifier(notificationCenter: NotificationCenter.default),
        authenticationService: AuthenticationService(),
        deauthenticationService: DeauthenticationService(),
        accessTokenProviderObserver: AuthenticationAccessTokenProviderObserver(broadcast: AuthenticationAccessTokenProviderBroadcast()),

        deviceTokenProvider: InstanceID.instanceID(),
        deviceRegisterService: APIService(),
        deviceTokenDeleter: InstanceID.instanceID(),

        uiAccessibility: UIAccessibility.self,
        keyboardDismisser: UIApplication.shared,
        urlOpener: UIApplication.shared,
        mapOpener: MapOpener(urlOpener: UIApplication.shared),
        router: Router(),

        imageLoadingService: ImageLoadingService(),

        bookingRequestRepository: Repository(),
        bookingRequestFetchingService: APIService(),
        bookingRequestApplyingService: APIService(),

        bookingApplicationRepository: Repository(),
        bookingApplicationFetchingService: APIService(),
        bookingApplicationRetractionService: APIService()
    )
}

extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy.with {
            $0.setUpFake()

            $0.mapOpener = MapOpener(urlOpener: UIApplication.shared)

            $0.bookingRequestFetchingService = fakeAPIService(result: .success([.stub, .longStub]))
            $0.bookingRequestApplyingService = fakeAPIService(result: .success(.stub))
            $0.bookingApplicationFetchingService = fakeAPIService(result: .success([.longStub, .stubWithAbout] + .stub))
            $0.bookingApplicationRetractionService = fakeAPIService(result: .success(.stub))
        }
    }
}

extension AppEnvironment {
    static var dummy: AppEnvironment {
        AppEnvironment(
            date: { .stub },
            calendar: Calendar(identifier: .gregorian),
            locale: Locale(identifier: "en_GB"),
            timeZone: TimeZone(identifier: "Europe/London")!,

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

            uiAccessibility: UIAccessibilityDummy.self,
            keyboardDismisser: KeyboardDismisserDummy(),
            urlOpener: URLOpenerDummy(),
            mapOpener: MapOpenerDummy(),
            router: Router(),

            imageLoadingService: ImageLoadingServiceDummy(),

            bookingRequestRepository: Repository(),
            bookingRequestFetchingService: APIServiceDummy(),
            bookingRequestApplyingService: APIServiceDummy(),

            bookingApplicationRepository: Repository(),
            bookingApplicationFetchingService: APIServiceDummy(),
            bookingApplicationRetractionService: APIServiceDummy()
        )
    }
}
