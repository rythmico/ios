import APIKit
import TutorDO

struct GetLessonPlanRequestsRequest: APIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/tutor/lesson-plan-requests"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = [LessonPlanRequest]
}

struct LessonPlanRequestApplyRequest: APIRequest {
    var lessonPlanRequestID: LessonPlanRequest.ID
    var privateNote: String

    let method: HTTPMethod = .post
    var path: String { "/booking-requests/\(lessonPlanRequestID)/apply" }
    var headerFields: [String: String] = [:]
    var body: some Encodable {
        struct Body: Encodable {
            var privateNote: String
        }
        return Body(privateNote: privateNote)
    }

    typealias Response = BookingApplication
}
