import Foundation

final class RequestLessonPlanCoordinatorStub: RequestLessonPlanCoordinatorBase {
    var expectedState: RequestLessonPlanCoordinatorState
    var delay: TimeInterval?

    init(expectedState: RequestLessonPlanCoordinatorState, delay: TimeInterval? = nil) {
        self.expectedState = expectedState
        self.delay = delay
    }

    override func requestLessonPlan(_ body: RequestLessonPlanBody) {
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

final class RequestLessonPlanCoordinatorSpy: RequestLessonPlanCoordinatorBase {
    var requestCount = 0
    var latestRequestBody: RequestLessonPlanBody?

    init(_ noop: Void = ()) {}

    override func requestLessonPlan(_ body: RequestLessonPlanBody) {
        requestCount += 1
        latestRequestBody = body
    }
}

final class RequestLessonPlanCoordinatorDummy: RequestLessonPlanCoordinatorBase {
    init(_ noop: Void = ()) {}
}
