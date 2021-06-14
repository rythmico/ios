import Foundation
import FoundationSugar
import Then

extension AnalyticsEvent {
    static func lessonPlanRequested(_ lessonPlan: LessonPlan) -> Self {
        Self(name: "[Action] Plan Requested", props: lessonPlanProps(lessonPlan))
    }
}
