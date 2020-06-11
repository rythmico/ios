import APIKit
import Sugar

protocol LessonPlanRequestServiceProtocol: AnyObject {
    typealias CompletionHandler = SimpleResultHandler<LessonPlan>
    func requestLessonPlan(accessToken: String, body: LessonPlanRequestBody, completion: @escaping CompletionHandler)
}

final class LessonPlanRequestService: LessonPlanRequestServiceProtocol {
    func requestLessonPlan(accessToken: String, body: LessonPlanRequestBody, completion: @escaping CompletionHandler) {
        let session = Session(adapter: URLSessionAdapter(configuration: .ephemeral))
        let request = CreateLessonPlanRequest(accessToken: accessToken, body: body)
        session.send(request, callbackQueue: .main) { result in
            completion(result.mapError { $0 as Error })
        }
    }
}

struct LessonPlanRequestBody: Encodable {
    var instrument: Instrument
    var student: Student
    var address: AddressDetails
    var schedule: Schedule
    var privateNote: String
}

private struct CreateLessonPlanRequest: RythmicoAPIRequest {
    let accessToken: String
    let body: LessonPlanRequestBody

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
