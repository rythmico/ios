import APIKit
import PhoneNumberKit

struct GetLessonPlansRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/lesson-plans"
    var headerFields: [String: String] = [:]

    typealias Response = [LessonPlan]
}

struct CreateLessonPlanRequest: RythmicoAPIRequest {
    var instrument: Instrument
    var student: Student
    var address: Address
    var schedule: Schedule
    var privateNote: String

    let method: HTTPMethod = .post
    let path: String = "/lesson-plans"
    var headerFields: [String: String] = [:]

    var bodyParameters: BodyParameters? {
        struct Body: Encodable {
            var instrument: Instrument
            var student: Student
            var address: Address
            var schedule: Schedule
            var privateNote: String
        }
        return JSONEncodableBodyParameters(
            object: Body(
                instrument: instrument,
                student: student,
                address: address,
                schedule: schedule,
                privateNote: privateNote
            )
        )
    }

    typealias Response = LessonPlan
}

struct PauseLessonPlanRequest: RythmicoAPIRequest {
    var lessonPlanID: LessonPlan.ID

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(lessonPlanID)/pause" }
    var headerFields: [String: String] = [:]

    typealias Response = LessonPlan
}

struct ResumeLessonPlanRequest: RythmicoAPIRequest {
    let lessonPlanID: LessonPlan.ID

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(lessonPlanID)/resume" }
    var headerFields: [String: String] = [:]

    typealias Response = LessonPlan
}

struct CancelLessonPlanRequest: RythmicoAPIRequest {
    typealias Reason = LessonPlan.CancellationInfo.Reason

    var lessonPlanID: LessonPlan.ID
    var reason: Reason

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(lessonPlanID)/cancel" }
    var headerFields: [String: String] = [:]

    var bodyParameters: BodyParameters? {
        struct Body: Encodable {
            var reason: Reason
        }
        return JSONEncodableBodyParameters(object: Body(reason: reason))
    }

    typealias Response = LessonPlan
}

struct SkipLessonRequest: RythmicoAPIRequest {
    var lesson: Lesson

    let method: HTTPMethod = .patch
    var path: String { "/lesson-plans/\(lesson.lessonPlanId)/lessons/\(lesson.id)/skip" }
    var headerFields: [String: String] = [:]

    typealias Response = LessonPlan
}

struct GetLessonPlanCheckoutRequest: RythmicoAPIRequest {
    var lessonPlanID: LessonPlan.ID
    var applicationID: Tutor.ID

    let method: HTTPMethod = .get
    var path: String { "/lesson-plans/\(lessonPlanID)/applications/\(applicationID)/checkout" }
    var headerFields: [String: String] = [:]

    typealias Response = Checkout
}

struct CompleteLessonPlanCheckoutRequest: RythmicoAPIRequest {
    var lessonPlanID: LessonPlan.ID
    var applicationID: Tutor.ID
    var phoneNumber: PhoneNumber
    var cardID: Card.ID

    let method: HTTPMethod = .post
    var path: String { "/lesson-plans/\(lessonPlanID)/applications/\(applicationID)/book" }
    var headerFields: [String: String] = [:]

    var bodyParameters: BodyParameters? {
        struct Body: Encodable {
            @E164PhoneNumber
            var phoneNumber: PhoneNumber
            var cardID: Card.ID
        }
        return JSONEncodableBodyParameters(object: Body(phoneNumber: phoneNumber, cardID: cardID))
    }

    typealias Response = LessonPlan
}
