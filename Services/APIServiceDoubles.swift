import Foundation

final class APIServiceStub<Request: AuthorizedAPIRequest>: APIServiceBase<Request> {
    var result: Result<Response, Error>
    var delay: TimeInterval?

    init(result: Result<Response, Error>, delay: TimeInterval?) {
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
    var sendCount = 0

    override func send(_ request: Request, completion: @escaping CompletionHandler) {
        sendCount += 1
    }
}

typealias APIServiceDummy<Request: AuthorizedAPIRequest> = APIServiceBase<Request>
