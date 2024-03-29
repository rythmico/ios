import FoundationEncore

extension AnalyticsEvent {
    static func bookTutorScreenView(lessonPlan: LessonPlan, application: LessonPlan.Application) -> Self {
        Self(
            name: "[Screenview] Checkout Flow - Book Tutor",
            props: Props {
                ["Checkout Flow ID": checkoutFlowID.uuidString]
                lessonPlanProps(lessonPlan)
            }
        )
    }
}
