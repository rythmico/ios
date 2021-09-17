import SwiftUI

typealias LessonPlanReschedulingView = Alert
extension LessonPlanReschedulingView {
    static func reschedulingView(lessonPlan: LessonPlan) -> LessonPlanReschedulingView {
        Alert(
            title: Text("Rescheduling"),
            message: Text(
                """
                If you wish to reschedule this plan, please contact us and we'll do it for you.
                """
            ),
            primaryButton: .default(Text("Contact Us")) { Current.urlOpener.openMailToRescheduleLessonPlan(lessonPlan) },
            secondaryButton: .cancel()
        )
    }
}

typealias LessonReschedulingView = Alert
extension LessonReschedulingView {
    static func reschedulingView(lesson: Lesson) -> LessonReschedulingView {
        Alert(
            title: Text("Rescheduling"),
            message: Text(
                """
                As per our policy, you can reschedule a lesson at least 24h in advance.

                You can also reschedule your entire plan to a different date and time.

                If you wish to do either, please contact us and we'll do it for you.
                """
            ),
            primaryButton: .default(Text("Contact Us")) { Current.urlOpener.openMailToRescheduleLesson(lesson) },
            secondaryButton: .cancel()
        )
    }
}

private extension URLOpener {
    func openMailToRescheduleLessonPlan(_ plan: LessonPlan) {
        try? open(
            .mail(
                to: ["reschedule@rythmico.com"],
                subject: "Rescheduling request",
                body: plan.isRequest
                    ? "I'm requesting to reschedule my lesson plan (ID number \(plan.shortId.rawValue)) to the following start date and time:"
                    : "I’m requesting to reschedule my lesson plan (ID number \(plan.shortId.rawValue)) to the following day of the week and time:"
            )
        )
    }

    func openMailToRescheduleLesson(_ lesson: Lesson) {
        try? open(
            .mail(
                to: ["reschedule@rythmico.com"],
                subject: "Rescheduling request",
                body: "I'm requesting to reschedule my lesson (ID number \(lesson.shortId.rawValue)) to the following date and time:"
            )
        )
    }
}

private extension LessonPlan {
    var shortId: LessonPlan.ID {
        .init(rawValue: String(id.rawValue.prefix(6)))
    }
}

private extension Lesson {
    var shortId: Lesson.ID {
        .init(rawValue: String(id.rawValue.prefix(6)))
    }
}
