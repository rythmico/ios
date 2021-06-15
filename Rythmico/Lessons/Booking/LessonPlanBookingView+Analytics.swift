import Foundation
import FoundationSugar
import Then

extension AnalyticsEvent {
    static func lessonPlanBooked(_ lessonPlan: LessonPlan) -> Self {
        Self(
            name: "[Action] Plan Booked",
            props: Props {
                ["Flow ID": checkoutFlowID.uuidString]
                lessonPlanProps(lessonPlan)
            }
        )
    }
}
