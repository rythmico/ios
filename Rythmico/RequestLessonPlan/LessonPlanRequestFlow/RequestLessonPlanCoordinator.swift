import Foundation
import Combine

enum RequestLessonPlanCoordinatorState {
    case idle
    case loading
    case failure(Error)
    case success(LessonPlan)
}

class RequestLessonPlanCoordinatorBase: ObservableObject {
    @available(*, unavailable) init() {}

    @Published
    var state: RequestLessonPlanCoordinatorState = .idle
    func requestLessonPlan(_ body: RequestLessonPlanBody) {}
}

final class RequestLessonPlanCoordinator: RequestLessonPlanCoordinatorBase {
    private let service: RequestLessonPlanServiceProtocol

    init(service: RequestLessonPlanServiceProtocol) {
        self.service = service
    }

    override func requestLessonPlan(_ body: RequestLessonPlanBody) {
        state = .loading
        service.requestLessonPlan(body) { result in
            switch result {
            case .success(let lessonPlan):
                self.state = .success(lessonPlan)
            case .failure(let error):
                self.state = .failure(error)
            }
        }
    }
}
