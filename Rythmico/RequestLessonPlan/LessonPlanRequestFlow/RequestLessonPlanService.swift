import APIKit
import Sugar

protocol RequestLessonPlanServiceProtocol: AnyObject {
    typealias CompletionHandler = SimpleResultHandler<LessonPlan>
    func requestLessonPlan(_ body: RequestLessonPlanBody, completion: @escaping CompletionHandler)
}

final class RequestLessonPlanService: RequestLessonPlanServiceProtocol {
    private let accessTokenProvider: AuthenticationAccessTokenProvider

    init(accessTokenProvider: AuthenticationAccessTokenProvider) {
        self.accessTokenProvider = accessTokenProvider
    }

    func requestLessonPlan(_ body: RequestLessonPlanBody, completion: @escaping CompletionHandler) {
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                let session = Session(adapter: URLSessionAdapter(configuration: .ephemeral))
                let request = CreateLessonPlanRequest(accessToken: accessToken, body: body)
                session.send(request, callbackQueue: .main) { result in
                    completion(result.mapError { $0 as Error })
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct RequestLessonPlanBody: Encodable {
    var instrument: Instrument
    var student: Student
    var address: AddressDetails
    var schedule: Schedule
    var privateNote: String
}

private struct CreateLessonPlanRequest: RythmicoAPIRequest {
    let accessToken: String
    let body: RequestLessonPlanBody

    let method: HTTPMethod = .post
    let path: String = "/lesson-plans"

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: body)
    }
}

extension CreateLessonPlanRequest {
    typealias Response = LessonPlan
    typealias Error = RythmicoAPIError
}
