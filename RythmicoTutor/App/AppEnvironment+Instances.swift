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
        bookingRequestRepository: BookingRequestRepository(),
        bookingRequestFetchingService: BookingRequestFetchingService(),
        deviceTokenProvider: InstanceID.instanceID(),
        deviceRegisterService: DeviceRegisterService(),
        deviceTokenDeleter: InstanceID.instanceID(),
        keyboardDismisser: UIApplication.shared,
        uiAccessibility: UIAccessibility.self,
        urlOpener: UIApplication.shared
    )
}

extension AppEnvironment {
    static var fake: AppEnvironment {
        dummy.with {
            $0.userAuthenticated()
            $0.date = { dummy.date() + (fakeReferenceDate.distance(to: Date())) }
            $0.appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
            $0.authenticationService = AuthenticationServiceStub(result: .success(fakeAccessTokenProvider), delay: 2)
            $0.deauthenticationService = DeauthenticationServiceStub()
            $0.bookingRequestFetchingService = BookingRequestFetchingServiceStub(result: .success([.stub, .longStub]), delay: 1)
        }
    }

    private static let fakeReferenceDate = Date()
    private static let fakeAccessTokenProvider = AuthenticationAccessTokenProviderStub(result: .success("ACCESS_TOKEN"))
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
            bookingRequestRepository: BookingRequestRepository(),
            bookingRequestFetchingService: BookingRequestFetchingServiceDummy(),
            deviceTokenProvider: DeviceTokenProviderDummy(),
            deviceRegisterService: DeviceRegisterServiceDummy(),
            deviceTokenDeleter: DeviceTokenDeleterDummy(),
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
