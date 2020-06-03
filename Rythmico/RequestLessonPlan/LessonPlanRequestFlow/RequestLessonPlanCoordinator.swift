import Foundation
import Combine

enum RequestLessonPlanCoordinatorState {
    case idle
    case loading
    case failure(Error)
    case success(LessonPlan)
}

class RequestLessonPlanCoordinatorBase: ObservableObject {
    @Published
    var state: RequestLessonPlanCoordinatorState = .idle
    func requestLessonPlan(_ body: RequestLessonPlanBody) {}
}

final class RequestLessonPlanCoordinator: RequestLessonPlanCoordinatorBase {
    private let service: RequestLessonPlanServiceProtocol
    private let repository: LessonPlanRepository

    init(service: RequestLessonPlanServiceProtocol, repository: LessonPlanRepository) {
        self.service = service
        self.repository = repository
    }

    override func requestLessonPlan(_ body: RequestLessonPlanBody) {
        state = .loading
        service.requestLessonPlan(body) { result in
            switch result {
            case .success(let lessonPlan):
                self.state = .success(lessonPlan)
                self.repository.lessonPlans.insert(lessonPlan, at: 0)
            case .failure(let error):
                self.state = .failure(error)
            }
        }
    }
}
