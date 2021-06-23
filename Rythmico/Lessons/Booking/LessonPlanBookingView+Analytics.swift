import FoundationSugar

extension AnalyticsEvent {
    static func lessonPlanBooked(_ lessonPlan: LessonPlan) -> Self {
        Self(
            name: "[Action] Plan Booked",
            props: Props {
                ["Checkout Flow ID": checkoutFlowID.uuidString]
                lessonPlanProps(lessonPlan)
            }
        )
    }
}
