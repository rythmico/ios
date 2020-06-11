import Foundation
import class UIKit.UIApplication
import struct UIKit.UIAccessibility
import class UserNotifications.UNUserNotificationCenter
import class FirebaseInstanceID.InstanceID

struct AppEnvironment {
    var keychain: KeychainProtocol

    var appleAuthorizationService: AppleAuthorizationServiceProtocol
    var appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateProvider
    var appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifying
    var authenticationService: AuthenticationServiceProtocol
    var deauthenticationService: DeauthenticationServiceProtocol

    var accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase

    var instrumentSelectionListProvider: InstrumentSelectionListProviderProtocol
    var addressSearchService: AddressSearchServiceProtocol

    var lessonPlanFetchingService: LessonPlanFetchingServiceProtocol
    var lessonPlanRequestService: LessonPlanRequestServiceProtocol
    var lessonPlanRepository: LessonPlanRepository

    var deviceTokenProvider: DeviceTokenProvider
    var deviceRegisterService: DeviceRegisterServiceProtocol
    var deviceTokenDeleter: DeviceTokenDeleter

    var pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator

    var keyboardDismisser: KeyboardDismisser
    var uiAccessibility: UIAccessibilityProtocol.Type
    var urlOpener: URLOpener
}

extension AppEnvironment {
    func addressSearchCoordinator() -> AddressSearchCoordinator? {
        guard let accessTokenProvider = accessTokenProviderObserver.currentProvider else {
            return nil
        }
        return AddressSearchCoordinator(
            accessTokenProvider: accessTokenProvider,
            service: addressSearchService
        )
    }

    func lessonPlanFetchingCoordinator() -> LessonPlanFetchingCoordinator? {
        guard let accessTokenProvider = accessTokenProviderObserver.currentProvider else {
            return nil
        }
        return LessonPlanFetchingCoordinator(
            accessTokenProvider: accessTokenProvider,
            service: lessonPlanFetchingService,
            repository: lessonPlanRepository
        )
    }

    func lessonPlanRequestCoordinator() -> LessonPlanRequestCoordinator? {
        guard let accessTokenProvider = accessTokenProviderObserver.currentProvider else {
            return nil
        }
        return LessonPlanRequestCoordinator(
            accessTokenProvider: accessTokenProvider,
            service: lessonPlanRequestService,
            repository: lessonPlanRepository
        )
    }

    func deviceRegisterCoordinator() -> DeviceRegisterCoordinator? {
        guard let accessTokenProvider = accessTokenProviderObserver.currentProvider else {
            return nil
        }
        return DeviceRegisterCoordinator(
            accessTokenProvider: accessTokenProvider,
            deviceTokenProvider: deviceTokenProvider,
            service: deviceRegisterService
        )
    }

    func deviceUnregisterCoordinator() -> DeviceUnregisterCoordinator {
        return DeviceUnregisterCoordinator(deviceTokenDeleter: deviceTokenDeleter)
    }
}

extension AppEnvironment {
    static let live = AppEnvironment(
        keychain: Keychain.localKeychain,
        appleAuthorizationService: AppleAuthorizationService(controllerType: AppleAuthorizationController.self),
        appleAuthorizationCredentialStateProvider: AppleAuthorizationCredentialStateFetcher(),
        appleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifier(
            notificationCenter: NotificationCenter.default
        ),
        authenticationService: AuthenticationService(),
        deauthenticationService: DeauthenticationService(),
        accessTokenProviderObserver: AuthenticationAccessTokenProviderObserver(broadcast: AuthenticationAccessTokenProviderBroadcast()),
        instrumentSelectionListProvider: InstrumentSelectionListProvider(),
        addressSearchService: AddressSearchService(),
        lessonPlanFetchingService: LessonPlanFetchingService(),
        lessonPlanRequestService: LessonPlanRequestService(),
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

let isRunningPreviews = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

#if DEBUG
var Current = isRunningTests || isRunningPreviews ? AppEnvironment.dummy : AppEnvironment.live
#else
let Current = AppEnvironment.live
#endif
