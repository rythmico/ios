import APIKit
import Sugar

protocol LessonPlanCancellationServiceProtocol: AnyObject {
    typealias Reason = LessonPlan.CancellationInfo.Reason
    typealias CompletionHandler = SimpleResultHandler<LessonPlan>
    func cancelLessonPlan(accessToken: String, lessonPlanId: String, reason: Reason, completion: @escaping CompletionHandler)
}

final class LessonPlanCancellationService: LessonPlanCancellationServiceProtocol {
    func cancelLessonPlan(accessToken: String, lessonPlanId: String, reason: Reason, completion: @escaping CompletionHandler) {
        let session = Session(adapter: URLSessionAdapter(configuration: .ephemeral))
        let request = CancelLessonPlansRequest(accessToken: accessToken, lessonPlanId: lessonPlanId, body: .init(reason: reason))
        session.send(request, callbackQueue: .main) { result in
            completion(result.mapError { $0 as Error })
        }
    }
}

private struct CancelLessonPlansRequest: RythmicoAPIRequest {
    struct Body: Encodable {
        var reason: LessonPlan.CancellationInfo.Reason
    }

    let accessToken: String
    let lessonPlanId: String
    let body: Body

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(lessonPlanId)/cancel" }

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: body)
    }
}

extension CancelLessonPlansRequest {
    typealias Response = LessonPlan
    typealias Error = RythmicoAPIError
}
