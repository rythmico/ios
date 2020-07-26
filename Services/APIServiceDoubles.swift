import Foundation

final class APIServiceStub<Request: AuthorizedAPIRequest>: APIServiceBase<Request> {
    var result: Result<Response, Error>
    var delay: TimeInterval?

    init(result: Result<Response, Error>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    override func send(_ request: Request, completion: @escaping CompletionHandler) {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(self.result)
            }
        } else {
            completion(result)
        }
    }
}

final class APIServiceSpy<Request: AuthorizedAPIRequest>: APIServiceBase<Request> {
    private(set) var sendCount = 0
    private(set) var latestRequest: Request?

    var result: Result<Response, Error>?

    init(result: Result<Response, Error>? = nil) {
        self.result = result
    }

    override func send(_ request: Request, completion: @escaping CompletionHandler) {
        sendCount += 1
        latestRequest = request
        result.map(completion)
    }
}

typealias APIServiceDummy<Request: AuthorizedAPIRequest> = APIServiceBase<Request>
