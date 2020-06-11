import Foundation
import Combine

final class LessonPlanRequestCoordinator: ObservableObject {
    enum State {
        case idle
        case loading
        case failure(Error)
        case success(LessonPlan)
    }

    @Published
    var state: State = .idle

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let service: LessonPlanRequestServiceProtocol
    private let repository: LessonPlanRepository

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        service: LessonPlanRequestServiceProtocol,
        repository: LessonPlanRepository
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.service = service
        self.repository = repository
    }

    func requestLessonPlan(_ body: LessonPlanRequestBody) {
        state = .loading
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                self.service.requestLessonPlan(accessToken: accessToken, body: body) { result in
                    switch result {
                    case .success(let lessonPlan):
                        self.state = .success(lessonPlan)
                        self.repository.lessonPlans.insert(lessonPlan, at: 0)
                    case .failure(let error):
                        self.state = .failure(error)
                    }
                }
            case .failure(let error):
                self.state = .failure(error) // TODO: handle
            }
        }
    }
}
