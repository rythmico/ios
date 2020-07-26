import APIKit

struct GetLessonPlansRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/lesson-plans"

    typealias Response = [LessonPlan]
    typealias Error = RythmicoAPIError
}

struct CreateLessonPlanRequest: RythmicoAPIRequest {
    struct Body: Encodable {
        var instrument: Instrument
        var student: Student
        var address: AddressDetails
        var schedule: Schedule
        var privateNote: String
    }

    typealias Properties = Body

    let accessToken: String
    let properties: Properties

    let method: HTTPMethod = .post
    let path: String = "/lesson-plans"

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: self.properties)
    }

    typealias Response = LessonPlan
    typealias Error = RythmicoAPIError
}

struct CancelLessonPlanRequest: RythmicoAPIRequest {
    typealias Reason = LessonPlan.CancellationInfo.Reason

    struct Body: Encodable {
        var reason: Reason
    }

    typealias Properties = (lessonPlanId: String, body: Body)

    let accessToken: String
    let properties: Properties

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(self.lessonPlanId)/cancel" }

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: self.body)
    }

    typealias Response = LessonPlan
    typealias Error = RythmicoAPIError
}
