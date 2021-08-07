import SwiftUISugar

struct LessonsCollectionView: View {
    let lessonPlans: [LessonPlan]
    let lessons: [Lesson]

    init(lessonPlans: [LessonPlan], filter: LessonsView.Filter) {
        switch filter {
        case .upcoming:
            self.lessonPlans = lessonPlans.filterRequests()
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
    func filterRequests() -> [LessonPlan] {
        self.filter(\.isRequest)
            .sorted(by: \.schedule.startDate, <)
    }
}
