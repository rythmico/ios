import SwiftUISugar

struct LessonPlansCollectionView: View {
    let lessonPlans: [LessonPlan]

    var body: some View {
        CollectionView {
            ForEach(lessonPlans) { lessonPlan in
                LessonPlanSummaryCell(lessonPlan: lessonPlan).transition(transition)
            }
        }
    }

    private var transition: AnyTransition {
        (.scale(scale: 0.75) + .opacity).animation(.rythmicoSpring(duration: .durationMedium))
    }
}
