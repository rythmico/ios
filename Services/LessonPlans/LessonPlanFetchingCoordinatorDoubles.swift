import Foundation
import Sugar

final class LessonPlanFetchingCoordinatorStub: LessonPlanFetchingCoordinatorBase {
    var result: SimpleResult<[LessonPlan]>
    var delay: TimeInterval?
    let repository: LessonPlanRepository

    init(result: SimpleResult<[LessonPlan]>, delay: TimeInterval? = nil, repository: LessonPlanRepository) {
        self.result = result
        self.delay = delay
        self.repository = repository
    }

    override func fetchLessonPlans() {
        let completion = {
            switch self.result {
            case .success(let lessonPlans):
                self.repository.lessonPlans = lessonPlans
            case .failure(let error):
                self.error = error
            }
        }

        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: completion)
        } else {
            completion()
        }
    }
}
