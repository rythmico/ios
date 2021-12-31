import APIKit
import TutorDO

struct GetLessonPlanRequestsRequest: APIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/tutor/lesson-plan-requests"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = [LessonPlanRequest]
}

struct CreateLessonPlanApplicationRequest: APIRequest {
    let method: HTTPMethod = .post
    let path: String = "/tutor/lesson-plan-applications"
    var headerFields: [String : String] = [:]
    let body: CreateLessonPlanApplicationBody

    typealias Response = LessonPlanApplication
}
