import Foundation
import APIKit
import Sugar

final class LessonPlanFetchingServiceStub: LessonPlanFetchingServiceProtocol {
    var result: SimpleResult<[LessonPlan]>
    var delay: TimeInterval?

    init(result: SimpleResult<[LessonPlan]>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func lessonPlans(accessToken: String, completion: @escaping CompletionHandler) -> SessionTask? {
        let work = { completion(self.result) }
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
        } else {
            work()
        }
        return nil
    }
}

final class LessonPlanFetchingServiceDummy: LessonPlanFetchingServiceProtocol {
    func lessonPlans(accessToken: String, completion: @escaping CompletionHandler) -> SessionTask? {
        nil
    }
}
