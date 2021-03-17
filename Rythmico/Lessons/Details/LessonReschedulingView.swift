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
    static func reschedulingView(lesson: Lesson, lessonPlan: LessonPlan?) -> LessonReschedulingView {
        Alert(
            title: Text("Rescheduling"),
            message: Text(
                """
                As per our policy, you can reschedule a lesson at least 24h in advance.

                You can also reschedule your entire plan to a different date and time.

                If you wish to do either, please contact us and we'll do it for you.
                """
            ),
            primaryButton: .default(Text("Contact Us")) { Current.urlOpener.openMailToRescheduleLesson(lesson, plan: lessonPlan) },
            secondaryButton: .cancel()
        )
    }
}

private extension URLOpener {
    func openMailToRescheduleLessonPlan(_ plan: LessonPlan) {
        try? open(
            .mail(
                to: ["info@rythmico.com"],
                subject: "Rescheduling request",
                body: """
                Rescheduling form 📝

                - New start date for lessons:
                - New time for lessons:

                Thank you!

                ------------

                Useful info for our support team:

                Plan ID: \(plan.id.rawValue)
                UID: \(Current.userCredentialProvider.userCredential?.userId ?? "<none>")
                """
            )
        )
    }

    func openMailToRescheduleLesson(_ lesson: Lesson, plan: LessonPlan?) {
        try? open(
            .mail(
                to: ["info@rythmico.com"],
                subject: "Rescheduling request",
                body: """
                Rescheduling form 📝

                - New day for lesson:
                - New time for lesson:
                - Apply to all future lessons? (Yes/No):

                Thank you!

                ------------

                Useful info for our support team:

                Lesson ID: \(lesson.id)
                Plan ID: \(plan?.id.rawValue ?? "<none>")
                UID: \(Current.userCredentialProvider.userCredential?.userId ?? "<none>")
                """
            )
        )
    }
}
