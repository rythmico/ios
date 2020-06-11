import Foundation
import Combine

final class LessonPlanFetchingCoordinator: ObservableObject {
    enum State {
        case idle
        case loading
        case failure(Error)
    }

    @Published var state: State = .idle

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let service: LessonPlanFetchingServiceProtocol
    private let repository: LessonPlanRepository

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        service: LessonPlanFetchingServiceProtocol,
        repository: LessonPlanRepository
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.service = service
        self.repository = repository
    }

    func fetchLessonPlans() {
        state = .loading
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                self.service.lessonPlans(accessToken: accessToken) { result in
                    switch result {
                    case .success(let lessonPlans):
                        self.state = .idle
                        self.repository.lessonPlans = lessonPlans
                    case .failure(let error):
                        self.state = .failure(error)
                    }
                }
            case .failure(let error):
                self.state = .failure(error) // TODO: handle individual cases
            }
        }
    }

    func dismissError() {
        if state.failureValue != nil {
            state = .idle
        }
    }
}
