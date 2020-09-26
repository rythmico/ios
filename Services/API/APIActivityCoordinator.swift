import Foundation
import APIKit

final class APIActivityCoordinator<Request: AuthorizedAPIRequest>: FailableActivityCoordinator<Request.Response> {
    typealias Service = APIServiceBase<Request>

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let deauthenticationService: DeauthenticationServiceProtocol
    private let service: Service
    private var activity: Activity?

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        deauthenticationService: DeauthenticationServiceProtocol,
        service: Service
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.deauthenticationService = deauthenticationService
        self.service = service
    }

    override func cancel() {
        if case .loading = state {
            activity?.cancel()
        }
        super.cancel()
    }

    func start(with properties: Request.Properties) {
        start(with: properties, idleOnSuccess: false)
    }

    func startToIdle(with properties: Request.Properties) {
        start(with: properties, idleOnSuccess: true)
    }

    func run(with properties: Request.Properties) {
        run(with: properties, idleOnSuccess: false)
    }

    func runToIdle(with properties: Request.Properties) {
        run(with: properties, idleOnSuccess: true)
    }

    private func start(with properties: Request.Properties, idleOnSuccess: Bool) {
        guard state.isReady else { return }
        run(with: properties, idleOnSuccess: idleOnSuccess)
    }

    private func run(with properties: Request.Properties, idleOnSuccess: Bool) {
        state = .loading
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                do {
                    let request = try Request(accessToken: accessToken, properties: properties)
                    self.activity = self.service.send(request) {
                        self.handleRequestResult($0, idleOnSuccess: idleOnSuccess)
                    }
                } catch {
                    self.handleRequestError(error)
                }
            case .failure(let error):
                self.handleAuthenticationError(error)
            }
        }
    }

    private func handleRequestResult(_ result: Result<Request.Response, Error>, idleOnSuccess: Bool) {
        switch result {
        case .success:
            state = .finished(result)
            if idleOnSuccess { idle() }
        case .failure(let error):
            handleRequestError(error)
        }
    }

    private func handleRequestError(_ error: Error) {
        if let error = error as? SessionTaskError, error.isCancelledError {
            cancel()
        } else {
            state = .finished(.failure(error))
        }
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
    func startToIdle() { startToIdle(with: ()) }

    func run() { run(with: ()) }
    func runToIdle() { runToIdle(with: ()) }
}

private extension SessionTaskError {
    var isCancelledError: Bool {
        guard
            case .connectionError(let connectionError as NSError) = self,
            connectionError.domain == NSURLErrorDomain,
            connectionError.code == -999
        else {
            return false
        }
        return true
    }
}
