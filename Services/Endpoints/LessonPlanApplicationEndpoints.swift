import APIKit
import TutorDTO

struct GetLessonPlanApplicationsRequest: APIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/tutor/lesson-plan-applications"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = [LessonPlanApplication]
}

struct RetractLessonPlanApplicationsRequest: APIRequest {
    let lessonPlanApplicationID: LessonPlanApplication.ID

    let method: HTTPMethod = .patch
    var path: String { "/tutor/lesson-plan-applications/\(lessonPlanApplicationID)/retract" }
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = LessonPlanApplication
}
