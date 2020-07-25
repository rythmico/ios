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
    var addressSearchService: APIServiceBase<AddressSearchRequest>

    var lessonPlanFetchingService: APIServiceBase<GetLessonPlansRequest>
    var lessonPlanRequestService: APIServiceBase<CreateLessonPlanRequest>
    var lessonPlanCancellationService: APIServiceBase<CancelLessonPlanRequest>
    var lessonPlanRepository: Repository<LessonPlan>

    var deviceTokenProvider: DeviceTokenProvider
    var deviceRegisterService: APIServiceBase<AddDeviceRequest>
    var deviceTokenDeleter: DeviceTokenDeleter

    var pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator

    var keyboardDismisser: KeyboardDismisser
    var uiAccessibility: UIAccessibilityProtocol.Type
    var urlOpener: URLOpener
}

extension AppEnvironment {
    func addressSearchCoordinator() -> APIActivityCoordinator<AddressSearchRequest>? {
        coordinator(for: addressSearchService)
    }

    func lessonPlanFetchingCoordinator() -> APIActivityCoordinator<GetLessonPlansRequest>? {
        coordinator(for: lessonPlanFetchingService)
    }

    func lessonPlanRequestCoordinator() -> APIActivityCoordinator<CreateLessonPlanRequest>? {
        coordinator(for: lessonPlanRequestService)
    }

    func lessonPlanCancellationCoordinator() -> APIActivityCoordinator<CancelLessonPlanRequest>? {
        coordinator(for: lessonPlanCancellationService)
    }

    func deviceRegisterCoordinator() -> DeviceRegisterCoordinator? {
        coordinator(for: deviceRegisterService).map {
            DeviceRegisterCoordinator(deviceTokenProvider: deviceTokenProvider, apiCoordinator: $0)
        }
    }

    func deviceUnregisterCoordinator() -> DeviceUnregisterCoordinator {
        DeviceUnregisterCoordinator(deviceTokenDeleter: deviceTokenDeleter)
    }
}

private extension AppEnvironment {
    func coordinator<Request: AuthorizedAPIRequest>(for service: APIServiceBase<Request>) -> APIActivityCoordinator<Request>? {
        accessTokenProviderObserver.currentProvider.map {
            APIActivityCoordinator(accessTokenProvider: $0, deauthenticationService: deauthenticationService, service: service)
        }
    }
}
