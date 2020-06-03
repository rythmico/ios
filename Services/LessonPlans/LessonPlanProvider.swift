import APIKit
import Sugar

protocol LessonPlanProviderProtocol: AnyObject {
    typealias CompletionHandler = SimpleResultHandler<[LessonPlan]>
    func lessonPlans(completion: @escaping CompletionHandler)
}

final class LessonPlanProvidingService: LessonPlanProviderProtocol {
    private let accessTokenProvider: AuthenticationAccessTokenProvider

    init(accessTokenProvider: AuthenticationAccessTokenProvider) {
        self.accessTokenProvider = accessTokenProvider
    }

    func lessonPlans(completion: @escaping CompletionHandler) {
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                let session = Session(adapter: URLSessionAdapter(configuration: .ephemeral))
                let request = GetLessonPlansRequest(accessToken: accessToken)
                session.send(request, callbackQueue: .main) { result in
                    completion(result.mapError { $0 as Error })
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private struct GetLessonPlansRequest: RythmicoAPIRequest {
    let accessToken: String

    let method: HTTPMethod = .get
    let path: String = "/lesson-plans"
}

extension GetLessonPlansRequest {
    typealias Response = [LessonPlan]
    typealias Error = RythmicoAPIError
}
