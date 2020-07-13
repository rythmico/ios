import Foundation
import Then
import Sugar

import class UIKit.UIApplication
import class UserNotifications.UNUserNotificationCenter
import class FirebaseInstanceID.InstanceID

extension AppEnvironment: Then {}

extension AppEnvironment {
    private static let fakeReferenceDate = Date()

    static var fake: AppEnvironment {
        dummy.with {
            $0.userAuthenticated()
            $0.date = { dummy.date() + (fakeReferenceDate.distance(to: Date())) }
            $0.bookingRequestFetchingService = BookingRequestFetchingServiceStub(result: .success([.stub, .longStub]), delay: 1)
        }
    }
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

extension AppEnvironment {
    mutating func userAuthenticated() {
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(
            currentProvider: AuthenticationAccessTokenProviderStub(
                result: .success("ACCESS_TOKEN")
            )
        )
    }
}
