import SwiftUI
import FoundationSugar

struct LessonsCollectionView: View {
    var lessonPlans: [LessonPlan]
    var lessons: [Lesson]

    init(lessonPlans: [LessonPlan], filter: LessonsView.Filter) {
        let allLessons = lessonPlans.compactMap(\.lessons).flatten()
        switch filter {
        case .upcoming:
            self.lessonPlans = lessonPlans
                .filter(\.status.includeInLessonsView)
                .sorted(\.schedule.startDate, by: <)
            self.lessons = allLessons
                .filter { Current.date() < $0.schedule.endDate }
                .sorted(\.schedule.startDate, by: <)
        case .past:
            self.lessonPlans = []
            self.lessons = allLessons
                .filter { Current.date() > $0.schedule.endDate }
                .sorted(\.schedule.startDate, by: >)
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

private extension LessonPlan.Status {
    var includeInLessonsView: Bool {
        switch self {
        case .pending, .reviewing:
            return true
        case .active, .paused, .cancelled:
            return false
        }
    }
}
