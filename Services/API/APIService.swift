import APIKit
import Foundation
import FoundationSugar

class APIServiceBase<Request: AuthorizedAPIRequest> {
    typealias Response = Request.Response
    typealias Error = SessionTaskError
    typealias Result = Swift.Result<Response, Error>
    typealias CompletionHandler = Handler<Result>

    func send(_ request: Request, completion: @escaping CompletionHandler) -> Activity? { nil }
}

final class APIService<Request: AuthorizedAPIRequest>: APIServiceBase<Request> {
    private let sessionConfiguration = URLSessionConfiguration.ephemeral.then {
        $0.waitsForConnectivity = true
        $0.timeoutIntervalForResource = 150
    }

    override func send(_ request: Request, completion: @escaping CompletionHandler) -> Activity? {
        let session = Session(adapter: URLSessionAdapter(configuration: sessionConfiguration))
        return session.send(request, callbackQueue: .main, completionHandler: completion) as? Activity
    }
}
