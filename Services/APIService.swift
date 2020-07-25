import APIKit
import Sugar

class APIServiceBase<Request: AuthorizedAPIRequest> {
    typealias Response = Request.Response
    typealias CompletionHandler = SimpleResultHandler<Response>

    func send(_ request: Request, completion: @escaping CompletionHandler) {}
}

final class APIService<Request: AuthorizedAPIRequest>: APIServiceBase<Request> {
    private let sessionConfiguration = URLSessionConfiguration.ephemeral

    override func send(_ request: Request, completion: @escaping CompletionHandler) {
        let session = Session(adapter: URLSessionAdapter(configuration: sessionConfiguration))
        session.send(request, callbackQueue: .main) { result in
            completion(result.mapError { $0 as Error })
        }
    }
}
