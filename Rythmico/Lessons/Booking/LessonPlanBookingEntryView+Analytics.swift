import Foundation
import FoundationSugar

extension AnalyticsEvent {
    static func bookTutorScreenView(lessonPlan: LessonPlan, application: LessonPlan.Application) -> Self {
        Self(
            name: "[Screenview] Checkout Flow - Book Tutor",
            props: Props {
                ["Flow ID": checkoutFlowID.uuidString]
                lessonPlanProps(lessonPlan)
            }
        )
    }
}
