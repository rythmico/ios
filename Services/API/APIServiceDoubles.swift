import FoundationEncore
import APIKit

final class APIServiceStub<Request: APIRequest>: APIServiceBase<Request> {
    var result: Swift.Result<Response, Swift.Error>
    var delay: TimeInterval?

    init(result: Swift.Result<Response, Swift.Error>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    override func send(_ request: Request, completion: @escaping CompletionHandler) -> Activity? {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
                completion(result.mapError(SessionTaskError.responseError))
            }
        } else {
            completion(result.mapError(SessionTaskError.responseError))
        }
        return nil
    }
}

final class APIServiceSpy<Request: APIRequest>: APIServiceBase<Request> {
    private(set) var sendCount = 0
    private(set) var latestRequest: Request?

    var result: Swift.Result<Response, Swift.Error>?

    init(result: Swift.Result<Response, Swift.Error>? = nil) {
        self.result = result
    }

    override func send(_ request: Request, completion: @escaping CompletionHandler) -> Activity? {
        sendCount += 1
        latestRequest = request
        (result?.mapError(SessionTaskError.responseError)).map(completion)
        return nil
    }
}

typealias APIServiceDummy<Request: APIRequest> = APIServiceBase<Request>
