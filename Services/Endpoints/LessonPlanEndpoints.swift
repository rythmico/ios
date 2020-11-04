import APIKit
import PhoneNumberKit

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
        var address: Address
        var schedule: Schedule
        var privateNote: String
    }

    typealias Properties = Body

    let accessToken: String
    let properties: Properties

    let method: HTTPMethod = .post
    let path: String = "/lesson-plans"

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: properties)
    }

    typealias Response = LessonPlan
    typealias Error = RythmicoAPIError
}

struct CancelLessonPlanRequest: RythmicoAPIRequest {
    typealias Reason = LessonPlan.CancellationInfo.Reason

    struct Body: Encodable {
        var reason: Reason
    }

    typealias Properties = (lessonPlanId: LessonPlan.ID, body: Body)

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

struct GetLessonPlanCheckoutRequest: RythmicoAPIRequest {
    struct Properties {
        var lessonPlanId: LessonPlan.ID
        var applicationId: Tutor.ID
    }

    let accessToken: String
    let properties: Properties

    let method: HTTPMethod = .get
    var path: String { "/lesson-plans/\(self.lessonPlanId)/applications/\(self.applicationId)/checkout" }

    typealias Response = Checkout
    typealias Error = RythmicoAPIError
}

struct CompleteLessonPlanCheckoutRequest: RythmicoAPIRequest {
    struct Properties {
        struct Body: Encodable {
            @E164PhoneNumber
            var phoneNumber: PhoneNumber
            var cardId: Card.ID
        }

        var lessonPlanId: LessonPlan.ID
        var applicationId: Tutor.ID
        var body: Body
    }

    let accessToken: String
    let properties: Properties

    let method: HTTPMethod = .post
    var path: String { "/lesson-plans/\(self.lessonPlanId)/applications/\(self.applicationId)/book" }

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: self.body)
    }

    typealias Response = LessonPlan
    typealias Error = RythmicoAPIError
}
