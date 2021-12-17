import SwiftUIEncore

extension AppEnvironment {
    mutating func setUpFake() {
        appStatus = .init() => (\.isAppOutdated, false)

        useFakeDate()

        eventEmitter = .default

        settings = .fake
        keychain = KeychainFake()

        siwaAuthorizationService = SIWAAuthorizationServiceStub(result: .success(.stub))
        shouldSucceedAuthentication()
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

        imageLoadingCoordinator = {
            ImageLoadingCoordinator(
                loadingService: ImageLoadingServiceStub(
                    result: .success(UIImage(solidColor: .red)),
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
        userCredentialProvider = UserCredentialProviderStub(userCredential: .stub)
    }

    mutating func userUnauthenticated() {
        userCredentialProvider = UserCredentialProviderDummy()
    }

    mutating func shouldSucceedAuthentication() {
        stubAPIEndpoint(
            for: \.siwaCoordinator,
            service: APIServiceStub(
                result: .success(.init(userID: "USER_ID", accessToken: "ACCESS_TOKEN")),
                delay: Self.fakeAPIEndpointDelay
            )
        )
    }

    mutating func shouldFailAuthentication() {
        stubAPIEndpoint(
            for: \.siwaCoordinator,
            service: APIServiceStub(
                result: .failure(RuntimeError("Some error")),
                delay: Self.fakeAPIEndpointDelay
            )
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
            )
        )
    }

    func coordinator<Request: APIRequest>(for service: APIServiceBase<Request>) -> APIActivityCoordinator<Request> {
        APIActivityCoordinator(
            userCredentialProvider: userCredentialProvider,
            errorHandler: apiActivityErrorHandler,
            service: service
        )
    }

    mutating func stubAPIEndpoint<R: APIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, APIActivityCoordinator<R>>,
        service: APIServiceBase<R>
    ) {
        self[keyPath: coordinatorKeyPath] = coordinator(for: service)
    }

    mutating func stubAPIEndpoint<R: APIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = nil
    ) {
        stubAPIEndpoint(for: coordinatorKeyPath, service: APIServiceStub(result: result, delay: delay))
    }

    mutating func stubAPIEndpoint<R: APIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, () -> APIActivityCoordinator<R>>,
        service: APIServiceBase<R>
    ) {
        let coordinator = coordinator(for: service)
        self[keyPath: coordinatorKeyPath] = { coordinator }
    }

    mutating func stubAPIEndpoint<R: APIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, () -> APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = nil
    ) {
        stubAPIEndpoint(for: coordinatorKeyPath, service: APIServiceStub(result: result, delay: delay))
    }

    mutating func fakeAPIEndpoint<R: APIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = Self.fakeAPIEndpointDelay
    ) {
        stubAPIEndpoint(for: coordinatorKeyPath, result: result, delay: delay)
    }

    mutating func fakeAPIEndpoint<R: APIRequest>(
        for coordinatorKeyPath: WritableKeyPath<Self, () -> APIActivityCoordinator<R>>,
        result: Result<R.Response, Error>,
        delay: TimeInterval? = Self.fakeAPIEndpointDelay
    ) {
        stubAPIEndpoint(for: coordinatorKeyPath, result: result, delay: delay)
    }

    private static var fakeAPIEndpointDelay: TimeInterval? = 2
    private static let fakeReferenceDate = Date()
}
