import Foundation
import Sugar

final class RequestLessonPlanServiceStub: RequestLessonPlanServiceProtocol {
    var result: SimpleResult<LessonPlan>
    var delay: TimeInterval?

    init(result: SimpleResult<LessonPlan>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func requestLessonPlan(_ body: RequestLessonPlanBody, completion: @escaping CompletionHandler) {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(self.result)
            }
        } else {
            completion(result)
        }
    }
}

final class RequestLessonPlanServiceSpy: RequestLessonPlanServiceProtocol {
    var requestCount = 0

    func requestLessonPlan(_ body: RequestLessonPlanBody, completion: @escaping CompletionHandler) {
        requestCount += 1
    }
}

final class RequestLessonPlanServiceDummy: RequestLessonPlanServiceProtocol {
    func requestLessonPlan(_ body: RequestLessonPlanBody, completion: @escaping CompletionHandler) {
        // NO-OP
    }
}
