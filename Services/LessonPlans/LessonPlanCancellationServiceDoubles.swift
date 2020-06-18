import Foundation
import APIKit
import Sugar

final class LessonPlanCancellationServiceStub: LessonPlanCancellationServiceProtocol {
    var result: SimpleResult<LessonPlan>
    var delay: TimeInterval?

    init(result: SimpleResult<LessonPlan>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func cancelLessonPlan(accessToken: String, lessonPlanId: String, reason: Reason, completion: @escaping CompletionHandler) {
        let work = { completion(self.result) }
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
        } else {
            work()
        }
    }
}

final class LessonPlanCancellationServiceDummy: LessonPlanCancellationServiceProtocol {
    func cancelLessonPlan(accessToken: String, lessonPlanId: String, reason: Reason, completion: @escaping CompletionHandler) {}
}
