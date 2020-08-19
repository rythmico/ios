import Foundation

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
