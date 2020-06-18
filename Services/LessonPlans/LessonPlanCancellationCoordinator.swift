import Foundation
import Combine

final class LessonPlanCancellationCoordinator: ObservableObject {
    enum State {
        case idle
        case loading
        case failure(Error)
        case success(LessonPlan)
    }

    @Published var state: State = .idle

    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let service: LessonPlanCancellationServiceProtocol
    private let repository: LessonPlanRepository

    init(
        accessTokenProvider: AuthenticationAccessTokenProvider,
        service: LessonPlanCancellationServiceProtocol,
        repository: LessonPlanRepository
    ) {
        self.accessTokenProvider = accessTokenProvider
        self.service = service
        self.repository = repository
    }

    func cancelLessonPlan(_ lessonPlan: LessonPlan, reason: LessonPlan.CancellationInfo.Reason) {
        state = .loading
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                self.service.cancelLessonPlan(accessToken: accessToken, lessonPlanId: lessonPlan.id, reason: reason) { result in
                    switch result {
                    case .success(let lessonPlan):
                        self.state = .success(lessonPlan)
                        if let index = self.repository.lessonPlans.firstIndex(where: { $0.id == lessonPlan.id }) {
                            self.repository.lessonPlans[index] = lessonPlan
                        }
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
