import SwiftUI

struct LessonsCollectionView: View {
    var previousLessonPlans: [LessonPlan]?
    var currentLessonPlans: [LessonPlan]

    var body: some View {
        CollectionView(currentLessonPlans) { lessonPlan in
            LessonPlanSummaryCell(lessonPlan: lessonPlan)
                .transition(transition(for: lessonPlan))
        }
    }

    private func transition(for lessonPlan: LessonPlan) -> AnyTransition {
        let transitionDelay = currentLessonPlans
            .firstIndex(of: lessonPlan)
            .flatMap { previousLessonPlans.isNilOrEmpty ? $0 : nil }
            .map { Double($0) * (.durationShort * 2/3) }

        return AnyTransition.opacity.combined(with: .scale(scale: 0.8))
            .animation(
                Animation
                    .rythmicoSpring(duration: .durationMedium)
                    .delay(transitionDelay ?? 0)
            )
    }
}
