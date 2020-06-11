import APIKit
import Sugar

protocol LessonPlanFetchingServiceProtocol: AnyObject {
    typealias CompletionHandler = SimpleResultHandler<[LessonPlan]>
    func lessonPlans(accessToken: String, completion: @escaping CompletionHandler) -> SessionTask?
}

final class LessonPlanFetchingService: LessonPlanFetchingServiceProtocol {
    func lessonPlans(accessToken: String, completion: @escaping CompletionHandler) -> SessionTask? {
        let session = Session(adapter: URLSessionAdapter(configuration: .ephemeral))
        let request = GetLessonPlansRequest(accessToken: accessToken)
        return session.send(request, callbackQueue: .main) { result in
            completion(result.mapError { $0 as Error })
        }
    }
}

private struct GetLessonPlansRequest: RythmicoAPIRequest {
    let accessToken: String

    let method: HTTPMethod = .get
    let path: String = "/lesson-plans"
}

extension GetLessonPlansRequest {
    typealias Response = [LessonPlan]
    typealias Error = RythmicoAPIError
}
