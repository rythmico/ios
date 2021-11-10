import APIKit
import StudentDO

struct GetLessonPlanRequestsRequest: APIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/student/lesson-plan-requests"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = [LessonPlanRequest]
}

struct CreateLessonPlanRequestRequest: APIRequest {
    let method: HTTPMethod = .post
    let path: String = "/student/lesson-plan-requests"
    var headerFields: [String: String] = [:]
    let body: CreateLessonPlanRequestBody

    typealias Response = LessonPlanRequest
}
