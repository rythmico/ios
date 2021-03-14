import UIKit
import Then
import enum APIKit.SessionTaskError

extension AppEnvironment {
    func calendar() -> Calendar {
        Calendar(identifier: calendarType()).with {
            $0.locale = locale
            $0.timeZone = timeZone
        }
    }

    func numberFormatter(format: NumberFormatter.Format) -> NumberFormatter {
        NumberFormatter().then {
            $0.locale = locale
            $0.setFormat(format)
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

    func dateIntervalFormatter(format: DateIntervalFormatter.Format) -> DateIntervalFormatter {
        DateIntervalFormatter().then {
            $0.calendar = calendar()
            $0.locale = locale
            $0.timeZone = timeZone
            $0.setFormat(format)
        }
    }

    func dateComponentsFormatter(
        allowedUnits: NSCalendar.Unit,
        style: DateComponentsFormatter.UnitsStyle,
        includesTimeRemainingPhrase: Bool = false
    ) -> DateComponentsFormatter {
        DateComponentsFormatter().then {
            $0.calendar = calendar()
            $0.allowedUnits = allowedUnits
            $0.unitsStyle = style
            $0.includesTimeRemainingPhrase = includesTimeRemainingPhrase
        }
    }

    func relativeDateTimeFormatter(
        context: Formatter.Context,
        style: RelativeDateTimeFormatter.UnitsStyle,
        precise: Bool
    ) -> RelativeDateTimeFormatter {
        RelativeDateTimeFormatter().then {
            $0.calendar = calendar()
            $0.locale = locale
            $0.formattingContext = context
            $0.unitsStyle = style
            $0.dateTimeStyle = precise ? .numeric : .named
        }
    }

    func calendarSyncCoordinator() -> CalendarSyncCoordinator? {
        coordinator(for: \.calendarInfoFetchingService).map {
            CalendarSyncCoordinator(
                calendarSyncStatusProvider: calendarSyncStatusProvider,
                calendarInfoFetchingCoordinator: $0,
                eventEmitter: eventEmitter,
                urlOpener: urlOpener
            )
        }
    }

    func coordinator<Request: AuthorizedAPIRequest>(for service: KeyPath<AppEnvironment, APIServiceBase<Request>>) -> APIActivityCoordinator<Request>? {
        APIActivityCoordinator(
            userCredentialProvider: userCredentialProvider,
            deauthenticationService: deauthenticationService,
            errorHandler: apiActivityErrorHandler,
            service: self[keyPath: service]
        )
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

    var sceneState: UIApplication.State {
        UIApplication.shared.applicationState
    }
}

#if DEBUG
extension AppEnvironment {
    mutating func setUpFake() {
        remoteConfig = RemoteConfigStub(
            fetchingDelay: Self.fakeAPIServicesDelay,
            appUpdateRequired: false
        )

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

        calendarSyncStatusProvider = CalendarSyncStatusProviderStub(
            initialStatus: .notSynced,
            refreshedStatus: .synced
        )

        calendarInfoFetchingService = APIServiceStub(
            result: .success(.stub),
            delay: Self.fakeAPIServicesDelay
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
        userCredentialProvider = UserCredentialProviderStub(
            userCredential: Self.fakeUserCredential
        )
    }

    mutating func userUnauthenticated() {
        userCredentialProvider = UserCredentialProviderDummy()
    }

    mutating func shouldSucceedAuthentication() {
        authenticationService = AuthenticationServiceStub(
            result: .success(Self.fakeUserCredential),
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

    mutating func stubAPIEndpoint<R: AuthorizedAPIRequest>(
        for coordinator: WritableKeyPath<Self, APIActivityCoordinator<R>>,
        service: APIServiceBase<R>
    ) {
        self[keyPath: coordinator] = APIActivityCoordinator(
            userCredentialProvider: userCredentialProvider,
            deauthenticationService: deauthenticationService,
            errorHandler: apiActivityErrorHandler,
            service: service
        )
    }

    mutating func stubAPIEndpoint<R: AuthorizedAPIRequest>(
        for coordinator: WritableKeyPath<Self, APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = nil
    ) {
        stubAPIEndpoint(for: coordinator, service: APIServiceStub(result: result, delay: delay))
    }

    mutating func fakeAPIEndpoint<R: AuthorizedAPIRequest>(
        for coordinator: WritableKeyPath<Self, APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = Self.fakeAPIServicesDelay
    ) {
        stubAPIEndpoint(for: coordinator, result: result, delay: delay)
    }

    @available(*, deprecated, message: "Will be replaced by 'fakeAPIEndpoint(for:result:delay:)'")
    static func fakeAPIService<R: AuthorizedAPIRequest>(result: Result<R.Response, Error>) -> APIServiceStub<R> {
        APIServiceStub(result: result, delay: fakeAPIServicesDelay)
    }

    internal static var fakeAPIServicesDelay: TimeInterval? = 2
    private static let fakeReferenceDate = Date()
    private static var fakeUserCredential: UserCredentialProtocol {
        UserCredentialStub(result: .success("ACCESS_TOKEN"))
    }
    private static let fakeAuthenticationError = AuthenticationServiceStub.Error(
        reasonCode: .invalidCredential,
        localizedDescription: "Invalid credential"
    )
}
#endif
