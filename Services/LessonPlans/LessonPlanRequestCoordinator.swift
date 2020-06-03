import Foundation
import Combine

enum LessonPlanRequestCoordinatorState {
    case idle
    case loading
    case failure(Error)
    case success(LessonPlan)
}

class LessonPlanRequestCoordinatorBase: ObservableObject {
    @Published
    var state: LessonPlanRequestCoordinatorState = .idle
    func requestLessonPlan(_ body: LessonPlanRequestBody) {}
}

final class LessonPlanRequestCoordinator: LessonPlanRequestCoordinatorBase {
    private let service: LessonPlanRequestServiceProtocol
    private let repository: LessonPlanRepository

    init(service: LessonPlanRequestServiceProtocol, repository: LessonPlanRepository) {
        self.service = service
        self.repository = repository
    }

    override func requestLessonPlan(_ body: LessonPlanRequestBody) {
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
