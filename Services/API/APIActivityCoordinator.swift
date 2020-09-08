import APIKit

final class APIActivityCoordinator<Request: AuthorizedAPIRequest>: FailableActivityCoordinator<Request.Response> {
    typealias Service = APIServiceBase<Request>

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let deauthenticationService: DeauthenticationServiceProtocol
    private let service: Service
    private var runningTask: SessionTask?

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        deauthenticationService: DeauthenticationServiceProtocol,
        service: Service
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.deauthenticationService = deauthenticationService
        self.service = service
    }

    func start(with properties: Request.Properties) {
        guard state.isReady else { return }
        run(with: properties)
    }

    func run(with properties: Request.Properties) {
        state = .loading
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                do {
                    let request = try Request(accessToken: accessToken, properties: properties)
                    self.runningTask = self.service.send(request) { result in
                        self.state = .finished(result)
                    }
                } catch {
                    self.state = .finished(.failure(error))
                }
            case .failure(let error):
                self.handleAuthenticationError(error)
            }
        }
    }

    override func cancel() {
        runningTask?.cancel()
        super.cancel()
    }

    private func handleAuthenticationError(_ error: AuthenticationCommonError) {
        switch error.reasonCode {
        case .appNotAuthorized, .invalidAPIKey, .operationNotAllowed:
            deauthenticationService.deauthenticate()
        default:
            break
        }

        state = .finished(.failure(error))
    }
}

extension APIActivityCoordinator where Request.Properties == Void {
    func start() { start(with: ()) }
    func run() { run(with: ()) }
}
