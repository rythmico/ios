import FoundationSugar

extension AnalyticsEvent {
    static func tutorApplicationScreenView(lessonPlan: LessonPlan, application: LessonPlan.Application) -> Self {
        Self(
            name: "[Screenview] Checkout Flow - Tutor Application",
            props: Props {
                ["Checkout Flow ID": checkoutFlowID.uuidString]
                ["Has Private Note": application.privateNote.isBlank.not]
                lessonPlanProps(lessonPlan)
            }
        )
    }
}
