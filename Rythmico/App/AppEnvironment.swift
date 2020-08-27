import Foundation

struct AppEnvironment {
    var date: () -> Date

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

    var deviceTokenProvider: DeviceTokenProvider
    var deviceRegisterService: APIServiceBase<AddDeviceRequest>
    var deviceTokenDeleter: DeviceTokenDeleter

    var uiAccessibility: UIAccessibilityProtocol.Type
    var keyboardDismisser: KeyboardDismisser
    var urlOpener: URLOpener
    var router: Router

    var instrumentSelectionListProvider: InstrumentSelectionListProviderProtocol
    var addressSearchService: APIServiceBase<AddressSearchRequest>

    var lessonPlanFetchingService: APIServiceBase<GetLessonPlansRequest>
    var lessonPlanRequestService: APIServiceBase<CreateLessonPlanRequest>
    var lessonPlanCancellationService: APIServiceBase<CancelLessonPlanRequest>
    var lessonPlanRepository: Repository<LessonPlan>

    var pushNotificationAuthorizationCoordinator: PushNotificationAuthorizationCoordinator
}
