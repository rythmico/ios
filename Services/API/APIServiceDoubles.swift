#if DEBUG
import Foundation
import APIKit

final class APIServiceStub<Request: AuthorizedAPIRequest>: APIServiceBase<Request> {
    var result: Result<Response, Error>
    var delay: TimeInterval?

    init(result: Result<Response, Error>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    override func send(_ request: Request, completion: @escaping CompletionHandler) -> Activity? {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
                completion(result)
            }
        } else {
            completion(result)
        }
        return nil
    }
}

final class APIServiceSpy<Request: AuthorizedAPIRequest>: APIServiceBase<Request> {
    private(set) var sendCount = 0
    private(set) var latestRequest: Request?

    var result: Result<Response, Error>?

    init(result: Result<Response, Error>? = nil) {
        self.result = result
    }

    override func send(_ request: Request, completion: @escaping CompletionHandler) -> Activity? {
        sendCount += 1
        latestRequest = request
        result.map(completion)
        return nil
    }
}

typealias APIServiceDummy<Request: AuthorizedAPIRequest> = APIServiceBase<Request>
#endif
