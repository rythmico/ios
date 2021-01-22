import Foundation
import APIKit

final class APIActivityCoordinator<Request: AuthorizedAPIRequest>: FailableActivityCoordinator<Request.Properties, Request.Response> {
    typealias Service = APIServiceBase<Request>

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let deauthenticationService: DeauthenticationServiceProtocol
    private let errorHandler: APIActivityErrorHandlerProtocol
    private let service: Service

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        deauthenticationService: DeauthenticationServiceProtocol,
        errorHandler: APIActivityErrorHandlerProtocol,
        service: Service
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.deauthenticationService = deauthenticationService
        self.errorHandler = errorHandler
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

    private func handleRequestResult(_ result: Service.Result) {
        switch result {
        case .success:
            finish(result.eraseError()) // TODO: stop erasing when FailableActivityCoordinator abstracts Error
        case .failure(let error):
            handleRequestError(error)
        }
    }

    private func handleRequestError(_ error: Error) {
        switch error {
        case let error as SessionTaskError where error.isCancelledError:
            cancel()
        case SessionTaskError.responseError(let rythmicoAPIError as RythmicoAPIError):
            handleRythmicoAPIError(rythmicoAPIError)
        default:
            finish(.failure(error))
        }
    }

    private func handleRythmicoAPIError(_ error: RythmicoAPIError) {
        errorHandler.handle(error)
        finish(.failure(error))
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
