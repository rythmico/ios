import Foundation
import Combine

class LessonPlanFetchingCoordinatorBase: ObservableObject {
    @Published var error: Error?
    func fetchLessonPlans() {}
}

final class LessonPlanFetchingCoordinator: LessonPlanFetchingCoordinatorBase {
    private let service: LessonPlanFetchingServiceProtocol
    private let repository: LessonPlanRepository

    init(service: LessonPlanFetchingServiceProtocol, repository: LessonPlanRepository) {
        self.service = service
        self.repository = repository
    }

    override func fetchLessonPlans() {
        service.lessonPlans { result in
            switch result {
            case .success(let lessonPlans):
                self.repository.lessonPlans = lessonPlans
            case .failure(let error):
                self.error = error
            }
        }
    }
}
