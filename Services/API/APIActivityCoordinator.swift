import Foundation
import APIKit

final class APIActivityCoordinator<Request: AuthorizedAPIRequest>: FailableActivityCoordinator<Request.Properties, Request.Response> {
    typealias Service = APIServiceBase<Request>

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let deauthenticationService: DeauthenticationServiceProtocol
    private let service: Service

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        deauthenticationService: DeauthenticationServiceProtocol,
        service: Service
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.deauthenticationService = deauthenticationService
        self.service = service
    }

    override func performTask(with input: Request.Properties) {
        super.performTask(with: input)
        accessTokenProvider.getAccessToken { [self] result in
            switch result {
            case .success(let accessToken):
                do {
                    let request = try Request(accessToken: accessToken, properties: input)
                    activity = service.send(request, completion: handleRequestResult)
                } catch {
                    handleRequestError(error)
                }
            case .failure(let error):
                handleAuthenticationError(error)
            }
        }
    }

    private func handleRequestResult(_ result: Result<Request.Response, Error>) {
        switch result {
        case .success:
            finish(result)
        case .failure(let error):
            handleRequestError(error)
        }
    }

    private func handleRequestError(_ error: Error) {
        if let error = error as? SessionTaskError, error.isCancelledError {
            cancel()
        } else {
            finish(.failure(error))
        }
    }

    private func handleAuthenticationError(_ error: AuthenticationCommonError) {
        switch error.reasonCode {
        case .appNotAuthorized, .invalidAPIKey, .operationNotAllowed:
            deauthenticationService.deauthenticate()
        default:
            break
        }
        finish(.failure(error))
    }
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
