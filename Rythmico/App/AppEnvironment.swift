import Foundation
import Sugar
import Then

struct AppEnvironment {
    var locale: Locale

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
    var lessonPlanCancellationService: LessonPlanCancellationServiceProtocol
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
        accessTokenProviderObserver.currentProvider.map {
            AddressSearchCoordinator(accessTokenProvider: $0, service: addressSearchService)
        }
    }

    func lessonPlanFetchingCoordinator() -> LessonPlanFetchingCoordinator? {
        accessTokenProviderObserver.currentProvider.map {
            LessonPlanFetchingCoordinator(accessTokenProvider: $0, service: lessonPlanFetchingService, repository: lessonPlanRepository)
        }
    }

    func lessonPlanRequestCoordinator() -> LessonPlanRequestCoordinator? {
        accessTokenProviderObserver.currentProvider.map {
            LessonPlanRequestCoordinator(accessTokenProvider: $0, service: lessonPlanRequestService, repository: lessonPlanRepository)
        }
    }

    func lessonPlanCancellationCoordinator() -> LessonPlanCancellationCoordinator? {
        accessTokenProviderObserver.currentProvider.map {
            LessonPlanCancellationCoordinator(accessTokenProvider: $0, service: lessonPlanCancellationService, repository: lessonPlanRepository)
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
