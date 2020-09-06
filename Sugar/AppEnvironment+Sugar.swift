import UIKit
import Then

extension AppEnvironment {
    func dateFormatter(format: DateFormatter.Format) -> DateFormatter {
        DateFormatter().then {
            $0.calendar = calendar
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
            $0.calendar = calendar
            $0.locale = locale
            $0.formattingContext = context
            $0.unitsStyle = style
        }
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

#if DEBUG
extension AppEnvironment {
    mutating func setUpFake() {
        useFakeDate()

        settings = UserDefaultsFake()
        keychain = KeychainFake()

        appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
        shouldSucceedAuthentication()
        deauthenticationService = DeauthenticationServiceStub()
        userAuthenticated()

        pushNotificationAuthorization(
            initialStatus: .notDetermined,
            requestResult: (true, nil)
        )

        keyboardDismisser = UIApplication.shared
        urlOpener = UIApplication.shared

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
    private static let fakeAccessTokenProvider = AuthenticationAccessTokenProviderStub(result: .success("ACCESS_TOKEN"))
    private static let fakeAuthenticationError = AuthenticationServiceStub.Error(
        reasonCode: .invalidCredential,
        localizedDescription: "Invalid credential"
    )
}
#endif
