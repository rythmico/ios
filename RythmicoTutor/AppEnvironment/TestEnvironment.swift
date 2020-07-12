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
        }
    }
}

extension AppEnvironment {
    static var dummy: AppEnvironment {
        AppEnvironment(
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

extension AppEnvironment {
    mutating func userAuthenticated() {
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(
            currentProvider: AuthenticationAccessTokenProviderStub(
                result: .success("ACCESS_TOKEN")
            )
        )
    }
}
