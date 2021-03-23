import UIKit
import Firebase
import Mixpanel
import Then
import enum APIKit.SessionTaskError

extension AppEnvironment {
    /// Simple wrapper to initialize AppEnvironment.live
    /// while ensuring all SDKs are configured as early as possible.
    static func initLive(_ build: () -> AppEnvironment) -> AppEnvironment {
        FirebaseApp.configure()

        Mixpanel.initialize(token: AppSecrets.mixpanelProjectToken)
        Mixpanel.mainInstance().serverURL = "https://api-eu.mixpanel.com"

        return build()
    }

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
}

#if DEBUG
extension AppEnvironment {
    mutating func setUpFake() {
        remoteConfig = RemoteConfigStub(
            fetchingDelay: Self.fakeAPIEndpointDelay,
            appUpdateRequired: false
        )
        remoteConfigCoordinator = RemoteConfigCoordinator(service: remoteConfig)

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

        calendarSyncCoordinator = CalendarSyncCoordinator(
            calendarSyncStatusProvider: CalendarSyncStatusProviderStub(
                initialStatus: .notSynced,
                refreshedStatus: .synced
            ),
            calendarInfoFetchingCoordinator: coordinator(
                for: APIServiceStub(
                    result: .success(.stub),
                    delay: Self.fakeAPIEndpointDelay
                )
            ),
            eventEmitter: eventEmitter,
            urlOpener: urlOpener
        )

        sceneState = { .active }
        keyboardDismisser = UIApplication.shared
        urlOpener = UIApplication.shared
        router = Router()

        imageLoadingCoordinator = {
            ImageLoadingCoordinator(
                loadingService: ImageLoadingServiceStub(
                    result: .success(UIImage(.red)),
                    delay: Self.fakeAPIEndpointDelay
                ),
                processingService: ImageProcessingServiceStub()
            )
        }

        #if RYTHMICO
        cardSetupCoordinator = {
            CardSetupCoordinator(
                service: CardSetupServiceStub(
                    result: .success(STPSetupIntentFake()),
                    delay: Self.fakeAPIEndpointDelay
                )
            )
        }
        #endif
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
            delay: Self.fakeAPIEndpointDelay
        )
    }

    mutating func shouldFailAuthentication() {
        authenticationService = AuthenticationServiceStub(
            result: .failure(Self.fakeAuthenticationError),
            delay: Self.fakeAPIEndpointDelay
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

    func coordinator<Request: AuthorizedAPIRequest>(for service: APIServiceBase<Request>) -> APIActivityCoordinator<Request> {
        APIActivityCoordinator(
            userCredentialProvider: userCredentialProvider,
            deauthenticationService: deauthenticationService,
            errorHandler: apiActivityErrorHandler,
            service: service
        )
    }

    mutating func stubAPIEndpoint<R: AuthorizedAPIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, APIActivityCoordinator<R>>,
        service: APIServiceBase<R>
    ) {
        self[keyPath: coordinatorKeyPath] = coordinator(for: service)
    }

    mutating func stubAPIEndpoint<R: AuthorizedAPIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = nil
    ) {
        stubAPIEndpoint(for: coordinatorKeyPath, service: APIServiceStub(result: result, delay: delay))
    }

    mutating func stubAPIEndpoint<R: AuthorizedAPIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, () -> APIActivityCoordinator<R>>,
        service: APIServiceBase<R>
    ) {
        let coordinator = coordinator(for: service)
        self[keyPath: coordinatorKeyPath] = { coordinator }
    }

    mutating func stubAPIEndpoint<R: AuthorizedAPIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, () -> APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = nil
    ) {
        stubAPIEndpoint(for: coordinatorKeyPath, service: APIServiceStub(result: result, delay: delay))
    }

    mutating func fakeAPIEndpoint<R: AuthorizedAPIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = Self.fakeAPIEndpointDelay
    ) {
        stubAPIEndpoint(for: coordinatorKeyPath, result: result, delay: delay)
    }

    mutating func fakeAPIEndpoint<R: AuthorizedAPIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, () -> APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = Self.fakeAPIEndpointDelay
    ) {
        stubAPIEndpoint(for: coordinatorKeyPath, result: result, delay: delay)
    }

    private static var fakeAPIEndpointDelay: TimeInterval? = 2
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
