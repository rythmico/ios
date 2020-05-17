import Foundation
import Combine

enum RequestLessonPlanCoordinatorState {
    case idle
    case loading
    case failure(Error)
    case success(LessonPlan)
}

final class RequestLessonPlanCoordinator: ObservableObject {
    @Published var state: RequestLessonPlanCoordinatorState = .idle

    private let service: RequestLessonPlanServiceProtocol

    init(service: RequestLessonPlanServiceProtocol) {
        self.service = service
    }

    func requestLessonPlan(_ body: RequestLessonPlanBody) {
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
