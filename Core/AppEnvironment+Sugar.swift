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

    var remoteConfigCoordinator: RemoteConfigCoordinator {
        cachedRemoteConfigCoordinator ?? RemoteConfigCoordinator(service: remoteConfig).then {
            cachedRemoteConfigCoordinator = $0
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

    func sharedCoordinator<Request: AuthorizedAPIRequest>(for service: KeyPath<AppEnvironment, APIServiceBase<Request>>) -> APIActivityCoordinator<Request>? {
        // Return nil if logged out.
        guard let userCredential = userCredentialProvider.userCredential else {
            latestUserCredential = nil
            coordinatorMap = [:]
            return nil
        }

        // Check if user changed and reset cache.
        if latestUserCredential != nil, userCredential !== latestUserCredential {
            latestUserCredential = nil
            coordinatorMap = [:]
        }

        // Update reference to latest provider.
        latestUserCredential = userCredential

        // Return cached coordinator if it exists.
        if let coordinator = coordinatorMap[service] as? APIActivityCoordinator<Request> {
            return coordinator
        }

        // Initialize, cache and return new coordinator if not.
        let coordinator = APIActivityCoordinator(
            userCredentialProvider: userCredentialProvider,
            deauthenticationService: deauthenticationService,
            errorHandler: apiErrorHandler,
            service: self[keyPath: service]
        )
        coordinatorMap[service] = coordinator
        return coordinator
    }

    func coordinator<Request: AuthorizedAPIRequest>(for service: KeyPath<AppEnvironment, APIServiceBase<Request>>) -> APIActivityCoordinator<Request>? {
        APIActivityCoordinator(
            userCredentialProvider: userCredentialProvider,
            deauthenticationService: deauthenticationService,
            errorHandler: apiErrorHandler,
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

private var cachedRemoteConfigCoordinator: RemoteConfigCoordinator?

private var latestUserCredential: UserCredentialProtocol?
private var coordinatorMap: [AnyKeyPath: Any] = [:]

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

    static var fakeAPIServicesDelay: TimeInterval? = 2
    static func fakeAPIService<R: AuthorizedAPIRequest>(result: Result<R.Response, Error>) -> APIServiceStub<R> {
        APIServiceStub(result: result, delay: fakeAPIServicesDelay)
    }

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
