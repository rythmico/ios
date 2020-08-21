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
        bookingRequestRepository: Repository(),
        bookingRequestFetchingService: APIService(),
        bookingRequestApplyingService: APIService(),
        bookingApplicationRepository: Repository(),
        bookingApplicationFetchingService: APIService(),
        deviceTokenProvider: InstanceID.instanceID(),
        deviceRegisterService: APIService(),
        deviceTokenDeleter: InstanceID.instanceID(),
        keyboardDismisser: UIApplication.shared,
        uiAccessibility: UIAccessibility.self,
        urlOpener: UIApplication.shared,
        mapOpener: MapOpener(urlOpener: UIApplication.shared),
        router: Router()
    )
}

extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy.with {
            $0.userAuthenticated()
            $0.date = { dummy.date() + (fakeReferenceDate.distance(to: Date())) }
            $0.appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
            $0.authenticationService = AuthenticationServiceStub(result: .success(AuthenticationAccessTokenProviderStub(result: .success("ACCESS_TOKEN"))), delay: fakeAPIServicesDelay)
            $0.deauthenticationService = DeauthenticationServiceStub()
            $0.bookingRequestFetchingService = APIServiceStub(result: .success([.stub, .longStub]), delay: fakeAPIServicesDelay)
            $0.bookingRequestApplyingService = APIServiceStub(result: .success(.stub), delay: fakeAPIServicesDelay)
            $0.bookingApplicationFetchingService = APIServiceStub(result: .success([.stub, .stubWithAbout]), delay: fakeAPIServicesDelay)
            $0.keyboardDismisser = UIApplication.shared
            $0.urlOpener = UIApplication.shared
            $0.mapOpener = MapOpener(urlOpener: UIApplication.shared)
        }
    }

    private static let fakeReferenceDate = Date()
    private static var fakeAPIServicesDelay: TimeInterval? = nil
}

extension AppEnvironment {
    static var dummy: AppEnvironment {
        AppEnvironment(
            date: { "2020-07-13T12:15:00Z" },
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
            bookingRequestRepository: Repository(),
            bookingRequestFetchingService: APIServiceDummy(),
            bookingRequestApplyingService: APIServiceDummy(),
            bookingApplicationRepository: Repository(),
            bookingApplicationFetchingService: APIServiceDummy(),
            deviceTokenProvider: DeviceTokenProviderDummy(),
            deviceRegisterService: APIServiceDummy(),
            deviceTokenDeleter: DeviceTokenDeleterDummy(),
            keyboardDismisser: KeyboardDismisserDummy(),
            uiAccessibility: UIAccessibilityDummy.self,
            urlOpener: URLOpenerDummy(),
            mapOpener: MapOpenerDummy(),
            router: Router()
        )
    }
}
