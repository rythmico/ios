import APIKit
import PhoneNumberKit
import StudentDTO

struct GetLessonPlansRequest: APIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/lesson-plans"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = [LessonPlan]
}

struct PauseLessonPlanRequest: APIRequest {
    var lessonPlanID: LessonPlan.ID

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(lessonPlanID)/pause" }
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = LessonPlan
}

struct ResumeLessonPlanRequest: APIRequest {
    let lessonPlanID: LessonPlan.ID

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(lessonPlanID)/resume" }
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = LessonPlan
}

struct CancelLessonPlanRequest: APIRequest {
    typealias Reason = LessonPlan.CancellationInfo.Reason

    var lessonPlanID: LessonPlan.ID
    var reason: Reason

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(lessonPlanID)/cancel" }
    var headerFields: [String: String] = [:]
    var body: some Encodable {
        struct Body: Encodable {
            var reason: Reason
        }
        return Body(reason: reason)
    }

    typealias Response = LessonPlan
}

struct SkipLessonRequest: APIRequest {
    var lesson: Lesson

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(lesson.lessonPlanId)/lessons/\(lesson.id)/skip" }
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = LessonPlan
}

struct GetLessonPlanCheckoutRequest: APIRequest {
    var lessonPlanID: LessonPlan.ID
    var applicationID: Tutor.ID

    let method: HTTPMethod = .get
    var path: String { "/lesson-plans/\(lessonPlanID)/applications/\(applicationID)/checkout" }
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = Checkout
}

struct CompleteLessonPlanCheckoutRequest: APIRequest {
    var lessonPlanID: LessonPlan.ID
    var applicationID: Tutor.ID
    var phoneNumber: PhoneNumber
    var cardID: Card.ID

    let method: HTTPMethod = .post
    var path: String { "/lesson-plans/\(lessonPlanID)/applications/\(applicationID)/book" }
    var headerFields: [String: String] = [:]
    var body: some Encodable {
        struct Body: Encodable {
            var phoneNumber: PhoneNumber
            var cardID: Card.ID
        }
        return Body(phoneNumber: phoneNumber, cardID: cardID)
    }

    typealias Response = LessonPlan
}
