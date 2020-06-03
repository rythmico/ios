import Foundation

final class LessonPlanRequestCoordinatorStub: LessonPlanRequestCoordinatorBase {
    var expectedState: LessonPlanRequestCoordinatorState
    var delay: TimeInterval?

    init(expectedState: LessonPlanRequestCoordinatorState, delay: TimeInterval? = nil) {
        self.expectedState = expectedState
        self.delay = delay
    }

    override func requestLessonPlan(_ body: LessonPlanRequestBody) {
        if let delay = delay {
            state = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.state = self.expectedState
            }
        } else {
            self.state = expectedState
        }
    }
}

final class LessonPlanRequestCoordinatorSpy: LessonPlanRequestCoordinatorBase {
    var requestCount = 0
    var latestRequestBody: LessonPlanRequestBody?

    override func requestLessonPlan(_ body: LessonPlanRequestBody) {
        requestCount += 1
        latestRequestBody = body
    }
}

final class LessonPlanRequestCoordinatorDummy: LessonPlanRequestCoordinatorBase {}
