import FoundationSugar

extension AnalyticsEvent {
    static private(set) var checkoutFlowID = Current.uuid()

    enum ChooseTutorScreenViewOrigin: String {
        case lessonsTabCell = "Lessons Tab - Cell"
        case lessonsTabDetail = "Lessons Tab - Detail"
    }

    static func chooseTutorScreenView(
        lessonPlan: LessonPlan,
        applications: LessonPlan.Applications,
        origin: ChooseTutorScreenViewOrigin
    ) -> Self {
        refreshCheckoutFlowID()
        return Self(
            name: "[Screenview] Checkout Flow - Choose Tutor",
            props: Props {
                ["Checkout Flow ID": checkoutFlowID.uuidString]
                ["Total Tutors": applications.count]
                ["Origin": origin.rawValue]
                lessonPlanProps(lessonPlan)
            }
        )
    }

    private static func refreshCheckoutFlowID() {
        checkoutFlowID = Current.uuid()
    }
}
