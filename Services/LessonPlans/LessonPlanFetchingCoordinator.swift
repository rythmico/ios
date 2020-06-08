import Foundation
import Combine

class LessonPlanFetchingCoordinatorBase: ObservableObject {
    enum State {
        case idle
        case loading
        case failure(Error)
    }

    @Published var state: State = .idle

    func fetchLessonPlans() {}
    func dismissError() {}
}

final class LessonPlanFetchingCoordinator: LessonPlanFetchingCoordinatorBase {
    private let service: LessonPlanFetchingServiceProtocol
    private let repository: LessonPlanRepository

    init(service: LessonPlanFetchingServiceProtocol, repository: LessonPlanRepository) {
        self.service = service
        self.repository = repository
    }

    override func fetchLessonPlans() {
        state = .loading
        service.lessonPlans { result in
            switch result {
            case .success(let lessonPlans):
                self.state = .idle
                self.repository.lessonPlans = lessonPlans
            case .failure(let error):
                self.state = .failure(error)
            }
        }
    }

    override func dismissError() {
        if state.failureValue != nil {
            state = .idle
        }
    }
}
