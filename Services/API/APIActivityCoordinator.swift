import APIKit
import CoreDTOEncore
import FoundationEncore

final class APIActivityCoordinator<Request: APIRequest>: FailableActivityCoordinator<Request, Request.Response> {
    typealias Service = APIServiceBase<Request>

    private let userCredentialProvider: UserCredentialProviderBase
    private let errorHandler: APIActivityErrorHandlerProtocol
    private let service: Service

    init(
        userCredentialProvider: UserCredentialProviderBase,
        errorHandler: APIActivityErrorHandlerProtocol,
        service: Service
    ) {
        self.userCredentialProvider = userCredentialProvider
        self.errorHandler = errorHandler
        self.service = service
    }

    override func performTask(with input: Request) {
        super.performTask(with: input)
        let clientInfo = APIClientInfo.current !! {
            preconditionFailure("Required client info is unavailable")
        }
        var request = input
        request.headerFields = request.headerFields + .init {
            if request.authRequired, let accessToken = userCredentialProvider.userCredential?.accessToken {
                ["Authorization": "Bearer " + accessToken]
            }
            clientInfo.encodeAsHTTPHeaders()
        }
        activity = service.send(request, completion: handleRequestResult)
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
