import UIKit
import Then

extension AppEnvironment {
    func calendar() -> Calendar {
        Calendar(identifier: calendarType()).with {
            $0.locale = locale
            $0.timeZone = timeZone
        }
    }

    func dateFormatter(format: DateFormatter.Format) -> DateFormatter {
        DateFormatter().then {
            $0.calendar = calendar()
            $0.locale = locale
            $0.timeZone = timeZone
            $0.setFormat(format)
        }
    }

    func relativeDateTimeFormatter(
        context: Formatter.Context,
        style: RelativeDateTimeFormatter.UnitsStyle
    ) -> RelativeDateTimeFormatter {
        RelativeDateTimeFormatter().then {
            $0.calendar = calendar()
            $0.locale = locale
            $0.formattingContext = context
            $0.unitsStyle = style
        }
    }

    func sharedCoordinator<Request: AuthorizedAPIRequest>(for service: KeyPath<AppEnvironment, APIServiceBase<Request>>) -> APIActivityCoordinator<Request>? {
        // Return nil if logged out.
        guard let currentProvider = accessTokenProviderObserver.currentProvider else {
            latestProvider = nil
            coordinatorMap = [:]
            return nil
        }

        // Check if user changed and reset cache.
        if currentProvider !== latestProvider {
            latestProvider = nil
            coordinatorMap = [:]
        }

        // Update reference to latest provider.
        latestProvider = currentProvider

        // Return cached coordinator if it exists.
        let key = AnyHashable(service)
        if let coordinator = coordinatorMap[key] as? APIActivityCoordinator<Request> {
            return coordinator
        }

        // Initialize, cache and return new coordinator if not.
        let coordinator = APIActivityCoordinator(
            accessTokenProvider: currentProvider,
            deauthenticationService: deauthenticationService,
            service: self[keyPath: service]
        )
        coordinatorMap[key] = coordinator
        return coordinator
    }

    func coordinator<Request: AuthorizedAPIRequest>(for service: KeyPath<AppEnvironment, APIServiceBase<Request>>) -> APIActivityCoordinator<Request>? {
        accessTokenProviderObserver.currentProvider.map {
            APIActivityCoordinator(accessTokenProvider: $0, deauthenticationService: deauthenticationService, service: self[keyPath: service])
        }
    }

    func imageLoadingCoordinator() -> ImageLoadingCoordinator {
        ImageLoadingCoordinator(service: imageLoadingService)
    }

    func deviceRegisterCoordinator() -> DeviceRegisterCoordinator? {
        coordinator(for: \.deviceRegisterService).map {
            DeviceRegisterCoordinator(deviceTokenProvider: deviceTokenProvider, apiCoordinator: $0)
        }
    }

    func deviceUnregisterCoordinator() -> DeviceUnregisterCoordinator {
        DeviceUnregisterCoordinator(deviceTokenDeleter: deviceTokenDeleter)
    }
}

private var latestProvider: AuthenticationAccessTokenProvider?
private var coordinatorMap: [AnyHashable: Any] = [:]

#if DEBUG
extension AppEnvironment {
    mutating func setUpFake() {
        useFakeDate()

        eventEmitter = .default

        settings = UserDefaultsFake()
        keychain = KeychainFake()

        appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
        shouldSucceedAuthentication()
        deauthenticationService = DeauthenticationServiceFake()
        userAuthenticated()

        pushNotificationAuthorization(
            initialStatus: .notDetermined,
            requestResult: (true, nil)
        )

        keyboardDismisser = UIApplication.shared
        urlOpener = UIApplication.shared
        router = Router()

        imageLoadingService = ImageLoadingServiceStub(
            result: .success(UIImage(.red)),
            delay: Self.fakeAPIServicesDelay
        )
    }

    mutating func useFakeDate() {
        date = { .stub + Self.fakeReferenceDate.distance(to: Date()) }
    }

    mutating func userAuthenticated() {
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverStub(
            currentProvider: Self.fakeAccessTokenProvider
        )
    }

    mutating func userUnauthenticated() {
        accessTokenProviderObserver = AuthenticationAccessTokenProviderObserverDummy()
    }

    mutating func shouldSucceedAuthentication() {
        authenticationService = AuthenticationServiceStub(
            result: .success(Self.fakeAccessTokenProvider),
            delay: Self.fakeAPIServicesDelay
        )
    }

    mutating func shouldFailAuthentication() {
        authenticationService = AuthenticationServiceStub(
            result: .failure(Self.fakeAuthenticationError),
            delay: Self.fakeAPIServicesDelay
        )
    }

    mutating func pushNotificationAuthorization(
        initialStatus: UNAuthorizationStatus,
        requestResult: (Bool, Error?)
    ) {
        pushNotificationAuthorizationCoordinator = PushNotificationAuthorizationCoordinator(
            center: UNUserNotificationCenterStub(
                authorizationStatus: initialStatus,
                authorizationRequestResult: requestResult
            ),
            registerService: PushNotificationRegisterServiceDummy()
        )
    }

    static var fakeAPIServicesDelay: TimeInterval? = nil
    static func fakeAPIService<R: AuthorizedAPIRequest>(result: Result<R.Response, Error>) -> APIServiceStub<R> {
        APIServiceStub(result: result, delay: fakeAPIServicesDelay)
    }

    private static let fakeReferenceDate = Date()
    private static var fakeAccessTokenProvider: AuthenticationAccessTokenProvider {
        AuthenticationAccessTokenProviderStub(result: .success("ACCESS_TOKEN"))
    }
    private static let fakeAuthenticationError = AuthenticationServiceStub.Error(
        reasonCode: .invalidCredential,
        localizedDescription: "Invalid credential"
    )
}
#endif
