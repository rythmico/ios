import FoundationEncore

extension AnalyticsEvent {
    static func lessonPlanRequested(_ lessonPlan: LessonPlan, through flow: RequestLessonPlanFlow) -> Self {
        Self(name: "[Action] Plan Requested", props: lessonPlanProps(lessonPlan) + flowProps(flow))
    }
}
