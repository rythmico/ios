import SwiftUI

struct LessonsCollectionView: View {
    var previousLessonPlans: [LessonPlan]?
    var currentLessonPlans: [LessonPlan]
    var filter: LessonsView.Filter

    var lessonPlans: [LessonPlan] {
        switch filter {
        case .upcoming:
            return currentLessonPlans
        case .past:
            return []
        }
    }

    var lessons: [Lesson] {
        let allLessons = currentLessonPlans.compactMap(\.lessons).flatten()
        switch filter {
        case .upcoming:
            return allLessons
                .filter { Current.date() < $0.schedule.endDate }
                .sorted { $0.schedule.startDate < $1.schedule.startDate }
        case .past:
            return allLessons
                .filter { Current.date() > $0.schedule.endDate }
                .sorted { $0.schedule.startDate > $1.schedule.startDate }
        }
    }

    var body: some View {
        CollectionView {
            ForEach(lessonPlans) { lessonPlan in
                LessonPlanSummaryCell(lessonPlan: lessonPlan).transition(transition)
            }
            ForEach(lessons) { lesson in
                LessonSummaryCell(lesson: lesson).transition(transition)
            }
        }
    }

    private var transition: AnyTransition {
        (.scale(scale: 0.75) + .opacity).animation(.rythmicoSpring(duration: .durationMedium))
    }
}
