import Foundation
import Sugar

final class LessonPlanRequestServiceStub: LessonPlanRequestServiceProtocol {
    var result: SimpleResult<LessonPlan>
    var delay: TimeInterval?

    init(result: SimpleResult<LessonPlan>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func requestLessonPlan(_ body: LessonPlanRequestBody, completion: @escaping CompletionHandler) {
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

    func requestLessonPlan(_ body: LessonPlanRequestBody, completion: @escaping CompletionHandler) {
        requestCount += 1
    }
}

final class LessonPlanRequestServiceDummy: LessonPlanRequestServiceProtocol {
    func requestLessonPlan(_ body: LessonPlanRequestBody, completion: @escaping CompletionHandler) {
        // NO-OP
    }
}
