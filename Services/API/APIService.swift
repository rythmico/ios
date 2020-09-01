import APIKit
import Sugar

class APIServiceBase<Request: AuthorizedAPIRequest> {
    typealias Response = Request.Response
    typealias CompletionHandler = SimpleResultHandler<Response>

    func send(_ request: Request, completion: @escaping CompletionHandler) -> SessionTask? { nil }
}

final class APIService<Request: AuthorizedAPIRequest>: APIServiceBase<Request> {
    private let sessionConfiguration = URLSessionConfiguration.ephemeral.then {
        $0.waitsForConnectivity = true
        $0.timeoutIntervalForResource = 150
    }

    override func send(_ request: Request, completion: @escaping CompletionHandler) -> SessionTask? {
        let session = Session(adapter: URLSessionAdapter(configuration: sessionConfiguration))
        return session.send(request, callbackQueue: .main) { result in
            completion(result.mapError { $0 as Error })
        }
    }
}
