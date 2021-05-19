import SwiftUI
import FoundationSugar

struct LessonsCollectionView: View {
    var lessonPlans: [LessonPlan]
    var lessons: [Lesson]

    init(lessonPlans: [LessonPlan], filter: LessonsView.Filter) {
        switch filter {
        case .upcoming:
            self.lessonPlans = lessonPlans.filterUpcoming()
            self.lessons = lessonPlans.allLessons().filterUpcoming()
        case .past:
            self.lessonPlans = []
            self.lessons = lessonPlans.allLessons().filterPast()
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

private extension RangeReplaceableCollection where Element == LessonPlan {
    func filterUpcoming() -> [LessonPlan] {
        self.filter(\.status.showAmongstLessons)
            .sorted(by: \.schedule.startDate, <)
    }

    func allLessons() -> [Lesson] {
        self.compactMap(\.lessons)
            .flatten()
    }
}

private extension LessonPlan.Status {
    var showAmongstLessons: Bool {
        switch self {
        case .pending, .reviewing:
            return true
        case .active, .paused, .cancelled:
            return false
        }
    }
}
