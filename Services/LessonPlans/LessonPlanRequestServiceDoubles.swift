import Foundation
import Sugar

final class LessonPlanRequestServiceStub: LessonPlanRequestServiceProtocol {
    var result: SimpleResult<LessonPlan>
    var delay: TimeInterval?

    init(result: SimpleResult<LessonPlan>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func requestLessonPlan(accessToken: String, body: LessonPlanRequestBody, completion: @escaping CompletionHandler) {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(self.result)
            }
        } else {
            completion(result)
        }
    }
}

final class LessonPlanRequestServiceSpy: LessonPlanRequestServiceProtocol {
    var requestCount = 0
    var latestRequestBody: LessonPlanRequestBody?

    func requestLessonPlan(accessToken: String, body: LessonPlanRequestBody, completion: @escaping CompletionHandler) {
        requestCount += 1
        latestRequestBody = body
    }
}

final class LessonPlanRequestServiceDummy: LessonPlanRequestServiceProtocol {
    func requestLessonPlan(accessToken: String, body: LessonPlanRequestBody, completion: @escaping CompletionHandler) {
        // NO-OP
    }
}
