import APIKit
import CoreDTOEncore
import FoundationEncore

enum APIActivityCoordinatorError: LocalizedError {
    case userCredentialsMissing

    var errorDescription: String? {
        switch self {
        case .userCredentialsMissing:
            return "User credentials missing"
        }
    }
}

final class APIActivityCoordinator<Request: RythmicoAPIRequest>: FailableActivityCoordinator<Request, Request.Response> {
    typealias Service = APIServiceBase<Request>
    typealias Error = APIActivityCoordinatorError

    private let userCredentialProvider: UserCredentialProviderBase
    private let deauthenticationService: DeauthenticationServiceProtocol
    private let errorHandler: APIActivityErrorHandlerProtocol
    private let service: Service

    init(
        userCredentialProvider: UserCredentialProviderBase,
        deauthenticationService: DeauthenticationServiceProtocol,
        errorHandler: APIActivityErrorHandlerProtocol,
        service: Service
    ) {
        self.userCredentialProvider = userCredentialProvider
        self.deauthenticationService = deauthenticationService
        self.errorHandler = errorHandler
        self.service = service
    }

    override func performTask(with input: Request) {
        super.performTask(with: input)
        guard let userCredential = userCredentialProvider.userCredential else {
            handleUserCredentialMissing()
            return
        }
        userCredential.getAccessToken { [self] result in
            switch result {
            case .success(let accessToken):
                let clientInfo = APIClientInfo.current !! {
                    preconditionFailure("Required client info is unavailable")
                }
                var request = input
                request.headerFields = request.headerFields + clientInfo.encodeAsHTTPHeaders()
                request.headerFields["Authorization"] = "Bearer " + accessToken
                activity = service.send(request, completion: handleRequestResult)
            case .failure(let error):
                handleAuthenticationError(error)
            }
        }
    }

    private func handleUserCredentialMissing() {
        deauthenticationService.deauthenticate()
        finish(.failure(Error.userCredentialsMissing))
    }

    private func handleRequestResult(_ result: Service.Result) {
        switch result {
        case .success:
            finish(result.eraseError()) // TODO: stop erasing when FailableActivityCoordinator abstracts Error
        case .failure(let error):
            handleRequestError(error)
        }
    }

    private func handleRequestError(_ error: Swift.Error) {
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
        case .invalidAPIKey, .appNotAuthorized, .operationNotAllowed, .userTokenExpired:
            deauthenticationService.deauthenticate()
        case .unknown, .internalError, .networkError, .tooManyRequests:
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
