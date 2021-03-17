import SwiftUI

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
            primaryButton: .default(Text("Contact Us")) { Current.urlOpener.openMailToReschedule(lessonId: lesson.id, lessonPlanId: lessonPlan?.id) },
            secondaryButton: .cancel()
        )
    }
}

private extension URLOpener {
    func openMailToReschedule(lessonId: Lesson.ID, lessonPlanId: LessonPlan.ID?) {
        try? open(
            .mail(
                to: ["info@rythmico.com"],
                subject: "Rescheduling request",
                body: """
                Rescheduling form 📝

                - New Day of lesson:
                - New Time of lesson:
                - Reschedule entire plan? (Yes/No):

                Thank you!

                ------------

                Useful info for our support team:

                Lesson ID: \(lessonId)
                Plan ID: \(lessonPlanId?.rawValue ?? "<none>")
                UID: \(Current.userCredentialProvider.userCredential?.userId ?? "<none>")
                """
            )
        )
    }
}
