import Foundation
import class UIKit.UIApplication
import struct UIKit.UIAccessibility
import class UserNotifications.UNUserNotificationCenter
import class FirebaseInstanceID.InstanceID
import Sugar
import Then

struct AppEnvironment {
    var calendar: Calendar
    var locale: Locale
    var timeZone: TimeZone

    var keychain: KeychainProtocol

    var appleAuthorizationService: AppleAuthorizationServiceProtocol
    var appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    var appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifying
    var authenticationService: AuthenticationServiceProtocol
    var deauthenticationService: DeauthenticationServiceProtocol

    var accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase

    var bookingRequestRepository: BookingRequestRepository
    var bookingRequestFetchingService: BookingRequestFetchingServiceProtocol

    var deviceTokenProvider: DeviceTokenProvider
    var deviceRegisterService: DeviceRegisterServiceProtocol
    var deviceTokenDeleter: DeviceTokenDeleter

    var keyboardDismisser: KeyboardDismisser
    var uiAccessibility: UIAccessibilityProtocol.Type
    var urlOpener: URLOpener
}

extension AppEnvironment {
    func dateFormatter(format: DateFormatter.Format) -> DateFormatter {
        DateFormatter(format: format).with {
            $0.calendar = calendar
            $0.locale = locale
            $0.timeZone = timeZone
        }
    }

    func bookingRequestFetchingCoordinator() -> BookingRequestFetchingCoordinator? {
        accessTokenProviderObserver.currentProvider.map {
            BookingRequestFetchingCoordinator(accessTokenProvider: $0, service: bookingRequestFetchingService, repository: bookingRequestRepository)
        }
    }

    func deviceRegisterCoordinator() -> DeviceRegisterCoordinator? {
        accessTokenProviderObserver.currentProvider.map {
            DeviceRegisterCoordinator(accessTokenProvider: $0, deviceTokenProvider: deviceTokenProvider, service: deviceRegisterService)
        }
    }

    func deviceUnregisterCoordinator() -> DeviceUnregisterCoordinator {
        DeviceUnregisterCoordinator(deviceTokenDeleter: deviceTokenDeleter)
    }
}

extension AppEnvironment {
    static let live = AppEnvironment(
        calendar: .autoupdatingCurrent,
        locale: .autoupdatingCurrent,
        timeZone: .autoupdatingCurrent,
        keychain: Keychain.localKeychain,
        appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
        appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
        appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifier(
            notificationCenter: NotificationCenter.default
        ),
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

#if DEBUG
var Current: AppEnvironment = isRunningTests || isRunningPreviews ? .dummy : .live
#else
let Current: AppEnvironment = .live
#endif
