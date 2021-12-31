import FoundationEncore
import StudentDTO

extension AnalyticsEvent {
    static func lessonPlanRequestCreated(
        _ lessonPlanRequest: LessonPlanRequest,
        through flow: RequestLessonPlanFlow
    ) -> Self {
        Self(
            name: "[Action] Plan Requested",
            props: lessonPlanRequestProps(lessonPlanRequest) + flowProps(flow)
        )
    }
}
